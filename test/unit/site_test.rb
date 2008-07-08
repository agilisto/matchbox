require File.dirname(__FILE__) + '/../test_helper'

class SiteTest < ActiveSupport::TestCase
  
  def setup
    @site = Site.create!(:name => "Mail & Guardian", :feed_url => "http://www.mg.co.za/rss", :identifier => "mg")
  end
  
  def test_fetch_stories
    assert @site.fetch_stories
    assert @site.stories.current.size == 10 # We've limited it to 10 (look at story.rb)

    assert @site.fetch_stories
    assert @site.stories.current.size == 10
  end

end
