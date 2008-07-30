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
    assert Matchbox.index
  end

  def test_generate_xml
    site2 = Site.create!(:name => "News24", :feed_url => "http://www.news24.com/rss", :identifier => "24")
    story1 = Story.create!(:uri => "http://uri.com/1", :title => "Nadal arrives home to hero welcome", :site => @site)
    story2 = Story.create!(:uri => "http://uri.com/2", :title => "Leopards forced to change their spots", :site => @site)
    story3 = Story.create!(:uri => "http://uri.com/3", :title => "Nothing relevant", :site => @site)
    story4 = Story.create!(:uri => "http://uri.com/4", :title => "Nadal too - but different site", :site => site2)
    product = Product.create!(:name => "Product", :keywords => "Nadal\nto\narrives", :link => "http://www.fnb.co.za", :link_text => "FNBTXT")

    assert Matchbox.expire_cache
    assert !File.exist?("#{Matchbox.cache_directory}/#{site2.identifier}.xml")

    assert Matchbox.index
    assert Matchbox.generate_ads

    assert document = File.open("#{Matchbox.cache_directory}/#{site2.identifier}.xml")

    xml = nil
    assert_nothing_thrown { xml = REXML::Document.new(document) }
  end
end
