require 'test_helper'

class DirectionsControllerTest < ActionController::TestCase
  test "should get get" do
    get :get
    assert_response :success
  end

end
