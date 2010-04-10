require 'test_helper'

class DraftboardControllerTest < ActionController::TestCase

  test "should get draftboard index" do
    get :index
    assert_response :success, @response.body
  end
  
  test "should get draftboard on_podium player" do
    get :index
    # assert assigns(:pick_announced)
    assert assigns(:picks)
    # pick current is nil since draft is done
    assert_equal(nil, assigns(:pick_current))
  end
  
  test "should get everything when not last pick" do
    x = Pick.on_podium.first
    x.player_id = nil
    x.save
    get :index
    # assert assigns(:pick_announced)
    assert assigns(:picks)
    # assert assigns(:pick_current)
  end
  
end
