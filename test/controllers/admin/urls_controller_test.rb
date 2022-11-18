require "test_helper"

class Admin::UrlsControllerTest < ActionDispatch::IntegrationTest
  test "get root should succeed" do
    url = urls(:url_example)
    get admin_root_path
    assert_response :success
    assert_select "h2", "Saved URLs"
    assert_select "a", url.full_url
  end

  test "index urls should succeed" do
    url = urls(:url_example)
    get admin_urls_path
    assert_response :success
    assert_select "h2", "Saved URLs"
    assert_select "a", url.full_url
  end

  test "destroy url should succeed" do
    url = urls(:url_example)
    delete admin_url_path(url)
    assert_response :see_other
  end

  test "destroy url should failed with invalid id" do
    delete admin_url_path(id: "ABC")
    assert_response :not_found
  end

end
