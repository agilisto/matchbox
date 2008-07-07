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
end
