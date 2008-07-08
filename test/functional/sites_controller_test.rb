require File.dirname(__FILE__) + '/../test_helper'

class SitesControllerTest < ActionController::TestCase

  def setup
    login_as :quentin
    super

    @site = Site.create!(:name => "Site", :feed_url => "http://somefeed.com", :identifier => "subdomain")
    @required_params = { :name => "Another Site", :feed_url => "http://anotherfeed.com", :identifier => "anothersubdomain" }
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  def test_should_get_index_with_search
    get :index, :n => "Si"
    assert_response :success
    assert_equal 1, assigns(:sites).size

    get :index, :n => "xx"
    assert_response :success
    assert_equal 0, assigns(:sites).size
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_site
    assert_difference('Site.count') do
      post :create, :site => @required_params
    end

    assert_redirected_to site_path(assigns(:site))
  end

  def test_should_show_site
    get :show, :id => @site.id
    assert_response :success
  end

  def test_should_show_site_with_stories
    assert @site.stories.create!(:uri => "http://someuri.com", :title => "Headline")
    @site.reload
    get :show, :id => @site.id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => @site.id
    assert_response :success
  end

  def test_should_update_site
    put :update, :id => @site.id, :site => { }
    assert_redirected_to site_path(assigns(:site))
  end

  def test_should_destroy_site
    assert_difference('Site.count', -1) do
      delete :destroy, :id => @site.id
    end

    assert_redirected_to sites_path
  end
  
  def test_should_fetch_stories
    @site.feed_url = "http://www.mg.co.za/rss"
    assert @site.save
    post :fetch_stories, :id => @site.id
    assert_redirected_to site_url(@site)
    assert !@site.stories.current.empty?
  end

  def test_should_not_fetch_stories
    @site.feed_url = "http://www.google.com"
    assert @site.save
    post :fetch_stories, :id => @site.id
    assert_redirected_to site_url(@site)
    assert @site.stories.current.empty?
    assert_equal "Couldn't fetch the stories. Is it a proper feed?", flash[:error]
  end
end
