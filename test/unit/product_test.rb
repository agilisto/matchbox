require File.dirname(__FILE__) + '/../test_helper'

class ProductTest < ActiveSupport::TestCase
	self.use_transactional_fixtures = false

  def setup
    # Cos we're not using transactional fixtures (else Sphinx doesn't see them in the DB)
    Site.delete_all
    Story.delete_all
    Product.delete_all
  end
  
  def test_score_stories_with_no_stories
    site = Site.create!(:name => "Mail & Guardian", :feed_url => "http://www.mg.co.za/rss", :identifier => "mg")
    story1 = Story.create!(:uri => "http://uri.com/1", :title => "Nadal arrives home to hero's welcome", :site => site)
    story2 = Story.create!(:uri => "http://uri.com/2", :title => "Leopards forced to change their spots", :site => site)
    product = Product.create!(:name => "Product", :keywords => "Nadal\nto\narrives")
    assert_equal "arrives", product.keywords.split("\n").last
    assert Matchbox.index_stories
    scores = product.score_stories(site)
    assert_equal 7642, scores[story1.id] # These score might change if we use different versions of Sphinx etc
    assert_equal 2356, scores[story2.id] # These score might change if we use different versions of Sphinx etc

    product.keywords = "Nadal arrives\nto"
    assert Matchbox.index_stories
    scores = product.score_stories(site)
    assert_equal 6999, scores[story1.id] # Wanted this one to be higher than 7642 - perhaps need to weight phrase matches over keyword matches ...
    assert_equal 2356, scores[story2.id] # These score might change if we use different versions of Sphinx etc
  end
end
