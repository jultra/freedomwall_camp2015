require 'test_helper'

class FreedomwallControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
