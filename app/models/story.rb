class Story < ActiveRecord::Base
  belongs_to :site
  
  validates_uniqueness_of :uri, :scope => :site_id

  named_scope :current, :conditions => { :expired_at => nil }, :order => "created_at DESC"
  named_scope :not_expired, :conditions => { :expired_at => nil }, :order => "created_at DESC"
  
  is_indexed  :fields => ["site_id", "title", "content"],
              :conditions => "expired_at is null"

  def expire!
    update_attribute :expired_at, Time.now
  end
end
