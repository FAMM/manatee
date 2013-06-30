require 'test_helper'

class SummariesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should show summary with filter" do
    get :show, id: {}.to_json
    assert_response :success
  end
end
