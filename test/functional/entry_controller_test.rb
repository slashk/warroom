require 'test_helper'

class EntryControllerTest < ActionController::TestCase

  test "should show index" do
    login_as :commish
    get :index
    assert_response :success
    assert_not_nil assigns(:pick)
    assert_not_nil assigns(:teams)
  end
  
  # test "should create entry" do
  #   post :create, :pick => {   }
  # end
  
  test "should update entry" do
    login_as :commish
    put :update, :pick => { :player_id => players(:players_022).id, :pick_number => picks(:one).pick_number, :user_id => users(:commish) }
    assert_redirected_to :action => :index
  end

  test "should not get index without admin" do
    login_as :elan
    get :index
    assert_redirected_to :action => "new", :controller => "session"
  end

  test "should not get index without login" do
    get :index
    assert_redirected_to :action => "new", :controller => "session"
  end


end
