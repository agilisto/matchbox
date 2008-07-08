require File.dirname(__FILE__) + '/../test_helper'

class FeedReaderTest < ActiveSupport::TestCase
  def test_gets_stories_from_good_rss
    stories = FeedReader.process("http://www.mg.co.za/rss") 
    assert stories.size > 0
  end

  def test_gets_stories_from_bad_rss
    assert_nil FeedReader.process("http://www.rubbish.com/rubbish") 
  end
end
