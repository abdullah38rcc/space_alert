require 'test_helper'

class DataControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get bexrb" do
    get :bexrb
    assert_response :success
  end

  test "should get news" do
    get :news
    assert_response :success
  end

end
