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

  test "should create pick" do
    login_as :commish
    assert_difference('Pick.count') do
      post :create, :pick => { :pick_number => 188, :user_id => users(:commish).id  }
    end
  
    assert_redirected_to pick_path(assigns(:pick))
  end

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
  
  test "should not error with no picks" do
    # destroy all picks
    Pick.all.each {|x| x.destroy}
    assert_equal([], Pick.all)
    login_as :commish
    get :index
    assert(@picks.nil?, "@picks is not empty")
    assert_response :success, @response.body
  end
  
  test "should return zero if draft has not started" do
    # no login needed
  end
  
  test "should get is_it_my_pick" do
    login_as :elan
    get :is_it_my_pick
    assert_response :success, @response.body
  end

  test "should be true when is_it_my_pick" do
    Pick.create(:user_id => users(:commish).id, :pick_number => Pick.count+1)
    login_as :commish
    get :is_it_my_pick
    assert_response :success, @response.body
    assert_equal("1", @response.body)
  end

  test "should be false when not is_it_my_pick" do
    Pick.create(:user_id => users(:commish).id, :pick_number => Pick.count+1)
    login_as :elan
    get :is_it_my_pick
    assert_response :success, @response.body
    assert_equal("0", @response.body)
  end
  
  test "should get scrolldraft" do
    login_as :elan
    get :scrolldraft
    assert_response :success, @response.body
  end

  test "should get scrollteam" do
    login_as :elan
    get :scrollteam
    assert_response :success, @response.body
  end
  
  test "should get inline" do
    login_as :elan
    get :inline
    assert_response :success, @response.body
  end

  test "should get myteam" do
    login_as :elan
    get :myteam
    assert_response :success, @response.body
  end
  
  test "should get ticker" do
    login_as :elan
    get :ticker
    assert_response :success, @response.body
  end
  
  # test "should get current_pick" do
  #     login_as :elan
  #     get :current_pick, :format => 'json'
  #     assert_response :success, @response.body
  #   end
  
  test "should draft player" do
    # create new pick as draft (fixtures) are over
    assert_difference "Pick.count", 1 do
      Pick.create(:pick_number => Pick.count+1, :user_id => users(:elan).id)      
    end
    login_as :elan
    assert_difference "Player.undrafted.count", -1 do
      post :draft, :player_id => Player.undrafted.last.id, :format => :json
    end
    assert_response :success, @response.body
  end

  test "should not draft player when its not our turn" do
    # create new pick as draft (fixtures) are over
    assert_difference "Pick.count", 1 do
      Pick.create(:pick_number => Pick.count+1, :user_id => users(:elan).id)      
    end
    login_as :commish
    assert_no_difference "Player.undrafted.count" do
      post :draft, :player_id => Player.undrafted.last.id, :format => :json
    end
    assert_response :success, @response.body
  end

  test "should not draft player when draft is over" do
    # create new pick as draft (fixtures) are over
    login_as :commish
    assert_no_difference "Player.undrafted.count" do
      post :draft, :player_id => Player.undrafted.last.id, :format => :json
    end
    assert_response :success, @response.body # is this really true ?
  end
 
  test "should get pick edit from index when admin" do
    login_as :commish
    get :index
    assert_select 'tr.individualDraftPick', :html => /picks/
  end

  test "should get yahoo link from index when user" do
    login_as :elan
    get :index
    assert_select 'tr.individualDraftPick', :html => /yahoo/
  end

  
end
