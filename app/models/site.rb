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
                      
  has_many :stories, :dependent => :destroy
  

  # Fetches stories from the feed_url, and expires any older stories.
  # We don't want to delete older stories - we might need it for historical reasons.
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
      
      # expire active stories that are no longer in this feed
      stories.not_expired.each do |story|
        story.expire! if !current_stories.find { |current| current.id == story.uri || current.urls.first == story.uri }
      end
      last_fetched_at!
      return true
    else
      return false
    end
  end
  
  # This creates the XML that matches products with headlines with relevancy values.
  # With this you can make a "tag cloud"
  # We loop through each products keywords and search for them in the stories, getting back relevancy scores.
  def ads
    ads_hash = {}
    
    Product.all.each do |product|
      product.score_stories(self).each do |story_score|
        story_id, score = *story_score
        ads_hash[story_id] = Ad.new(stories.current.find(story_id), product, score) if ads_hash[story_id].nil? || ads_hash[story_id].score < score
      end
    end
    ads = ads_hash.to_a.map { |key_ad| key_ad[1] } # Now we have an array of Ads
    ads.delete_if { |ad| !ad.relevant? }.sort { |a, b| a.score <=> b.score }.reverse
  end
  
  # This generates the xml representing all the ads
  def ads_xml_document
    x = Builder::XmlMarkup.new
    x.instruct! :xml, :version=>"1.0"
    x.matchbox {
      x.last_refreshed Setting.last_refreshed_at
      x.ads {
        ads.each do |ad|
          x << ad.to_xml
        end
      }
    }
  end
  
  def last_fetched_at!
    update_attribute :last_fetched_at, Time.now
  end
end
