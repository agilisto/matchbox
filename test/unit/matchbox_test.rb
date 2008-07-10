require File.dirname(__FILE__) + '/../test_helper'

class MatchboxTest < ActiveSupport::TestCase
  def test_fetches_stories_from_good_rss
    @site = Site.create!(:name => "Mail & Guardian", :feed_url => "http://www.mg.co.za/rss", :identifier => "mg")
    assert Matchbox.fetch_stories > 1
  end

  def test_fetches_stories_bad_good_rss
    @site = Site.create!(:name => "Mail & Guardian", :feed_url => "http://www.mg.co.za", :identifier => "mg")
    assert_equal 0, Matchbox.fetch_stories
  end

  def test_index_stories
    assert output = Matchbox.index_stories
    assert_match /Index rotated ok/, output
  end
  
end
