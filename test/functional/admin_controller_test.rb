require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  test "should get index" do
    login_as :commish
    get :index
    assert_response :success, @response.body
  end

  test "should get new" do
    login_as :commish
    get :new
    assert_response :success, @response.body
  end
  
  test "should create draft straight" do
    login_as :commish
    post :create, :rounds => "10", :copy_retainee => false, :drop_draft => true, :draft_type => "straight"
    assert_redirected_to :action => :index
    assert_equal(80, Pick.count)
    assert_equal(User.all(:order => "draft_order asc").first.id, Pick.first(:order => "pick_number asc").user_id)
    assert_equal(User.all(:order => "draft_order asc").first.id, Pick.find_by_pick_number(User.count+1).user_id)
  end  

  test "should create draft snake" do
    login_as :commish
    post :create, :rounds => "10", :copy_retainee => false, :drop_draft => true, :draft_type => "snake"
    assert_redirected_to :action => :index
    # assert_equal(80, Pick.count)  NEED TO RESEARCH THIS
    assert_equal(User.all(:order => "draft_order asc").first.id, Pick.first(:order => "pick_number asc").user_id)
    assert_equal(User.all(:order => "draft_order asc").last.id, Pick.find_by_pick_number(User.count+1).user_id)
  end  


end
