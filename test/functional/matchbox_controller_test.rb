require 'rexml/document'
require File.dirname(__FILE__) + '/../test_helper'

class MatchboxControllerTest < ActionController::TestCase
	self.use_transactional_fixtures = false

  def setup
    # Cos we're not using transactional fixtures (else Sphinx doesn't see them in the DB)
    Site.delete_all
    Story.delete_all
    Product.delete_all

    @site = Site.create!(:name => "Mail & Guardian", :feed_url => "http://www.mg.co.za/rss", :identifier => "mg")
  end
  
  def test_no_existing_site_to_403
    @request.host = "missing.localhost"

    get :show
    assert_response 403

    @request.host = "www.localhost"

    get :show
    assert_response 403

    @request.host = "localhost"

    get :show
    assert_response 403
  end

  def test_existing
    @request.host = "#{@site.identifier}.localhost"

    get :show
    assert_response :success
    assert_match /xml version/, @response.body
  end
  
  def test_xml
    site2 = Site.create!(:name => "News24", :feed_url => "http://www.news24.com/rss", :identifier => "24")
    story1 = Story.create!(:uri => "http://uri.com/1", :title => "Nadal arrives home to hero welcome", :site => @site)
    story2 = Story.create!(:uri => "http://uri.com/2", :title => "Leopards forced to change their spots", :site => @site)
    story3 = Story.create!(:uri => "http://uri.com/3", :title => "Nothing relevant", :site => @site)
    story4 = Story.create!(:uri => "http://uri.com/4", :title => "Nadal too - but different site", :site => site2)
    product = Product.create!(:name => "Product", :keywords => "Nadal\nto\narrives")
    assert Matchbox.index_stories

    @request.host = "#{@site.identifier}.localhost"
    get :show
    assert_response :success
    assert_match /Nadal arrives home to hero welcome/, @response.body
    assert_no_match /Nothing relevant/, @response.body
    assert_no_match /Nadal too - but different site/, @response.body

    xml = nil
    assert_nothing_thrown { xml = REXML::Document.new(@response.body) }
  end
end
