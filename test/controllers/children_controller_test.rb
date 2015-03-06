require 'test_helper'

class ChildrenControllerTest < ActionController::TestCase
  test "should get missing" do
    get :missing
    assert_response :success
  end

end
