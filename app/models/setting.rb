# At this stage, just records when last we refreshed the stories (fetched and indexed)
# and when last we indexed them. (might happen without a refetch)
# We can include this info in the XML or just on the front end, and also
# use it to decide whether to server the XML or not - to ensure that headlines and
# relevancy data are kept in sync.
class Setting < ActiveRecord::Base
  private_class_method :new

  def self.get
    Setting.find(:first) || Setting.create
  end
  
  def self.last_refreshed_at
    Setting.get.last_refreshed_at rescue nil
  end

  def self.last_indexed_at
    Setting.get.last_indexed_at rescue nil
  end
  
  def self.last_refreshed_at!
    Setting.get.update_attribute :last_refreshed_at, Time.now
  end

  def self.last_indexed_at!
    Setting.get.update_attribute :last_indexed_at, Time.now
  end
end
