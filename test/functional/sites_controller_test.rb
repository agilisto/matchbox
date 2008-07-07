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
end
