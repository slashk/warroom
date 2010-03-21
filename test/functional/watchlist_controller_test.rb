require 'test_helper'

class WatchlistControllerTest < ActionController::TestCase

  test "make sure watchlist>show returns successfully" do
    login_as :elan
    get :show
    assert_response :success, @response.body
  end

end
