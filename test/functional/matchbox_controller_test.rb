require File.dirname(__FILE__) + '/../test_helper'

class MatchboxControllerTest < ActionController::TestCase

  def test_should_get_default
    get :default
    assert_response 404
  end
end
