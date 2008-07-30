require File.dirname(__FILE__) + '/../test_helper'

class ProductTest < ActiveSupport::TestCase
	self.use_transactional_fixtures = false

  def setup
    # Cos we're not using transactional fixtures (else Sphinx doesn't see them in the DB)
    Site.delete_all
    Story.delete_all
    Product.delete_all
  end
  
  def test_score_stories
    site = Site.create!(:name => "Mail & Guardian", :feed_url => "http://www.mg.co.za/rss", :identifier => "mg")
    site2 = Site.create!(:name => "News24", :feed_url => "http://www.news24.com/rss", :identifier => "24")
    story1 = Story.create!(:uri => "http://uri.com/1", :title => "Nadal arrives home to hero's welcome", :site => site)
    story2 = Story.create!(:uri => "http://uri.com/2", :title => "Leopards forced to change their spots", :site => site)
    story3 = Story.create!(:uri => "http://uri.com/3", :title => "Nothing relevant", :site => site)
    story4 = Story.create!(:uri => "http://uri.com/4", :title => "Nadal too - but different site", :site => site2)
    product = Product.create!(:name => "Product", :keywords => "Nadal\nto\narrives")

    assert_equal "arrives", product.keywords.split("\n").last
    assert Matchbox.index
    scores = product.score_stories(site)
    assert_equal [story1.id, 7809], scores.first  # These score might change if we use different versions of Sphinx etc
    assert_equal [story3.id, 0], scores.last

    product.keywords = "Nadal arrives\nto"
    assert Matchbox.index
    scores = product.score_stories(site)
    assert_equal [story1.id, 7183], scores.first  # These score might change if we use different versions of Sphinx etc
  end
end
