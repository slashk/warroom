require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  test "should get index" do
    login_as :commish
    get :index
    assert_response :success, @response.body
  end


end
