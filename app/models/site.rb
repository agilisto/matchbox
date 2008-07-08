require "feed_reader"

# News media providers that will host advertisements served by the system.
class Site < ActiveRecord::Base
  validates_presence_of :name, :feed_url, :identifier
  validates_uniqueness_of :identifier
  
  validates_length_of :identifier,
                      :within => 2..30
                      
  # The identifier could act as a subdomain too - hence the strict format
  validates_format_of :identifier,
                      :with => /^[0-9a-z]+$/,
                      :message => 'only lowercase letters and digits are allowed'

  validates_format_of :feed_url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,
                      :message => "doesn't look right (don't forget the protocol eg http://)",
                      :allow_nil => true,
                      :allow_blank => true
                      

  validates_format_of :homepage_url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,
  :message => "doesn't look right (don't forget the protocol eg http://)",
                      :allow_nil => true,
                      :allow_blank => true
                      
  has_many :stories
  

  def fetch_stories
    if current_stories = FeedReader.process(feed_url)
      current_stories.each do |story|
        begin
          stories.create!(:uri => story.id || story.urls.first,
                          :title => story.title,
                          :content => story.content)
        rescue ActiveRecord::RecordInvalid
          logger.warn($!) 
        end
      end
    end
    return true
  end
end
