require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  
  # tests needed:
  # all searches, most fragments
  
  test "should get index" do
    login_as :elan
    get :index
    assert_response :success
    assert_not_nil assigns(:players)
  end

  test "should not get anything without login" do
    ["new", "index", "show", "create", "edit", "update", "destroy"].each do |page|
      get page
      assert_redirected_to :action => "new", :controller => "session"
    end
  end

  test "should get new" do
    login_as :commish
    get :new
    assert_response :success
  end

  test "should create player" do
    login_as :commish
    assert_difference('Player.count') do
      post :create, :player => { :yahoo_ref => 10111, :player => 'Ken Pepple', :pos => '3B', :team => "ATL" }
    end

    assert_redirected_to player_path(assigns(:player))
  end

  test "should show player" do
    login_as :elan
    get :show, :id => players(:players_001).id
    assert_response :success
  end

  test "should get edit" do
    login_as :commish
    get :edit, :id => players(:players_001).id
    assert_response :success
  end

  test "should update player" do
    login_as :commish
    put :update, :id => players(:players_001).id, :player => { }
    assert_redirected_to player_path(assigns(:player))
  end

  test "should destroy player" do
    login_as :commish
    assert_difference('Player.count', -1) do
      delete :destroy, :id => players(:players_001).id
    end
    assert_redirected_to players_path
  end
  
  test "should show not found player when bad player_id" do
    login_as :commish
    get :show, :id => "dwfsf"
    assert_response :success, @response.body
  end
  
  test "should get redirected to admin without players" do
    Player.all.each {|x| x.destroy}
    login_as :commish
    get :index
    assert_redirected_to :controller => :admin
  end

  test "should get index without players" do
    Player.all.each {|x| x.destroy}
    login_as :elan
    get :index
    assert_redirected_to :controller => :admin
  end

  test "should not add duplicate players to a single users watchlist" do
    login_as :elan
    get :add_to_watchlist, :id => players(:players_001)
    assert_difference "Watchlist.find_all_by_player_id_and_user_id(players(:players_001), users(:elan)).count", 1 do
      get :add_to_watchlist, :id => players(:players_001).id
      assert_response :success, @response.body      
      get :add_to_watchlist, :id => players(:players_001).id
      assert_response 401, @response.body
    end
  end

  test "should add and then remove player to watchlist" do
    login_as :elan
    player_to_watch = Player.undrafted.first
    assert_difference "Watchlist.count", 1 do
      get :add_to_watchlist, :id => player_to_watch.id
      assert_response :success, @response.body
    end
    assert_difference "Watchlist.count", -1 do
      get :remove_from_watchlist, :id => player_to_watch.id
      assert_response :success, @response.body      
    end
  end

end
