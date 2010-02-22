require 'test_helper'

class PicksControllerTest < ActionController::TestCase
    
  test "should get index" do
    login_as :elan
    get :index
    assert_response :success
    assert_not_nil assigns(:picks)
  end

  test "should get new" do
    login_as :commish
    get :new
    assert_response :success
  end

  # test "should create pick" do
  #   assert_difference('Pick.count') do
  #     post :create, :pick => {  }
  #   end
  # 
  #   assert_redirected_to pick_path(assigns(:pick))
  # end

  test "should show pick" do
    login_as :commish
    get :show, :id => picks(:one).id
    assert_response :success
  end

  test "should not get anything without login" do
    ["new", "index", "show", "create", "edit", "update", "destroy"].each do |page|
      get page
      assert_redirected_to :action => "new", :controller => "session"
    end
  end


  test "should get edit" do
    login_as :commish
    get :edit, :id => picks(:one).id
    assert_response :success
  end

  test "should update pick" do
    login_as :commish
    put :update, :id => picks(:one).id, :pick => { :player_id => players(:players_022).id }
    assert_redirected_to pick_path(assigns(:pick))
  end

  test "should destroy pick" do
    login_as :commish
    assert_difference('Pick.count', -1) do
      delete :destroy, :id => picks(:one).id
    end

    assert_redirected_to picks_path
  end
end
