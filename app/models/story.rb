class Story < ActiveRecord::Base
  belongs_to :site
  
  validates_uniqueness_of :uri

  named_scope :current, :conditions => { :expired_at => nil }
end
