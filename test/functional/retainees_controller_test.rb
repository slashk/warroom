require 'test_helper'

class RetaineesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retainees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retainee" do
    assert_difference('Retainee.count') do
      post :create, :retainee => { }
    end

    assert_redirected_to retainee_path(assigns(:retainee))
  end

  test "should show retainee" do
    get :show, :id => retainees(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => retainees(:one).id
    assert_response :success
  end

  test "should update retainee" do
    put :update, :id => retainees(:one).id, :retainee => { }
    assert_redirected_to retainee_path(assigns(:retainee))
  end

  test "should destroy retainee" do
    assert_difference('Retainee.count', -1) do
      delete :destroy, :id => retainees(:one).id
    end

    assert_redirected_to retainees_path
  end
end
