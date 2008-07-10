require File.dirname(__FILE__) + '/../test_helper'

class SiteTest < ActiveSupport::TestCase
  
  def setup
    @site = Site.create!(:name => "Mail & Guardian", :feed_url => "http://www.mg.co.za/rss", :identifier => "mg")
  end
  
  def test_fetch_stories
    assert @site.fetch_stories
    size = @site.stories.current.size
    assert size > 1

    assert @site.fetch_stories
    assert @site.stories.current.size == size
  end

  def test_fetch_rubbish
    @site.feed_url = "http://www.google.com"
    assert @site.save
    assert !@site.fetch_stories
  end
end
