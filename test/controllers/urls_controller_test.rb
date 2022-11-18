require "test_helper"

class UrlsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get url_path
    assert_response :success
  end
end
