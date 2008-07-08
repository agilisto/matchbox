class Story < ActiveRecord::Base
  belongs_to :site
  
  validates_uniqueness_of :uri, :scope => :site_id

  named_scope :current, :conditions => { :expired_at => nil }, :limit => 10, :order => "created_at DESC"
end
