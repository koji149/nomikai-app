require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get success" do
    get api_success_url
    assert_response :success
  end

end
