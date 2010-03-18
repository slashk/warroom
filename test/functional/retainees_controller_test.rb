require 'test_helper'

class RetaineesControllerTest < ActionController::TestCase
    
  test "should get index" do
    login_as :commish
    get :index
    assert_response :success
    assert_not_nil assigns(:retainees)
  end

  test "should not get anything without login" do
    ["new", "index", "show", "create", "edit", "update", "destroy"].each do |page|
      get page
      assert_redirected_to :action => "new", :controller => "session"
    end
  end

  test "should get new" do
    login_as :elan
    get :new
    assert_response :success
  end

  test "should create retainee" do
    login_as :elan
    assert_difference('Retainee.count') do
      post :create, :retainee => { :user_id => 1, :player_id => 2235 }
    end

    assert_redirected_to retainee_path(assigns(:retainee))
  end

  test "should show retainee" do
    login_as :elan
    get :show, :id => retainees(:retainees_001).id
    assert_response :success
  end

  test "should get edit" do
    login_as :elan
    get :edit, :id => retainees(:retainees_001).id
    assert_response :success
  end

  test "should update retainee" do
    login_as :elan
    put :update, :id => retainees(:retainees_001).id, :retainee => { }
    assert_redirected_to retainee_path(assigns(:retainee))
  end

  test "should destroy retainee" do
    login_as :elan
    assert_difference('Retainee.count', -1) do
      delete :destroy, :id => retainees(:retainees_001).id
    end

    assert_redirected_to retainees_path
  end
  
  test "should get index without previous teams" do
    login_as :elan
    # wipe all previous team data
    all_players = Player.all
    all_players.each do |p|
      p.previousTeam = nil
      p.save
    end
    get :index
    assert_response :success, @response.body
    get :edit
    assert_response :success, @response.body
  end
  
end
