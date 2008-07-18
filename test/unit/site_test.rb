require File.dirname(__FILE__) + '/../test_helper'

class SiteTest < ActiveSupport::TestCase
	self.use_transactional_fixtures = false
  
  def setup
    # Cos we're not using transactional fixtures (else Sphinx doesn't see them in the DB)
    Site.delete_all
    Story.delete_all
    Product.delete_all

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
  
  def test_ads
    site2 = Site.create!(:name => "News24", :feed_url => "http://www.news24.com/rss", :identifier => "24")
    story1 = Story.create!(:uri => "http://uri.com/1", :title => "Nadal arrives home to hero's welcome", :site => @site)
    story2 = Story.create!(:uri => "http://uri.com/2", :title => "Leopards forced to change their spots", :site => @site)
    story3 = Story.create!(:uri => "http://uri.com/3", :title => "Nothing relevant", :site => @site)
    story4 = Story.create!(:uri => "http://uri.com/4", :title => "Nadal too - but different site", :site => site2)
    product = Product.create!(:name => "Product", :keywords => "Nadal\nto\narrives")
    assert Matchbox.index_stories

    @site.reload
    assert ads = @site.ads
    assert_equal 2, ads.size
    assert_equal story1, ads[0].story
    assert ads[0].score > 1
  end
  
  def test_ads_xml_document
    story = Story.create!(:uri => "http://uri.com/1", :title => "Nadal arrives home to hero's welcome", :site => @site)
    product = Product.create!(:name => "Product", :keywords => "Nadal\nto\narrives")
    assert Matchbox.index_stories

    @site.reload
    assert_equal "<?xml version=\"1.0\" encoding=\"UTF-8\"?><matchbox><last_refreshed></last_refreshed><ads><ad><story>Nadal arrives home to hero's welcome</story><product>Product</product><score>7500</score><ad_copy></ad_copy><product_link></product_link><product_link_text></product_link_text></ad></ads></matchbox>", @site.ads_xml_document
  end
end
