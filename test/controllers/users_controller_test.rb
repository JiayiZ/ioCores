require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get login_main" do
    get :login_main
    assert_response :success
  end

end
