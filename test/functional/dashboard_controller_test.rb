require File.dirname(__FILE__) + '/../test_helper'

class DashboardControllerTest < ActionController::TestCase

  def setup
    login_as :quentin
    super
  end
  
  def test_should_get_index
    get :index
    assert_response :success
  end
end
