require "test_helper"

class UrlsControllerTest < ActionDispatch::IntegrationTest
  test "get root should succeed" do
    get root_path
    assert_response :success
    assert_select "h2", "New URL"
  end

  test "new url should succeed" do
    get new_url_path
    assert_response :success
    assert_select "h2", "New URL"
  end

  test "show url should succeed" do
    url = urls(:url_example)
    get url_path(url)
    assert_response :success
    assert_select "h2", "New URL"
    assert_select 'input' do
      assert_select "[value=?]", url.full_url
    end
    assert_select "h3", "http://www.example.com/#{url.id}"
  end

  test "create url should succeed with existing URL" do
    url = urls(:url_example)
    post urls_path,
      params: { url: { full_url: url.full_url } }
    assert_redirected_to url_path(url)
  end

  test "create url should failed" do
    post urls_path,
      params: { url: { full_url: "http//42.fr" } }
    assert_response :unprocessable_entity
    assert_select "h2", "New URL"
    assert_select 'input' do
      assert_select "[value=?]", "http//42.fr"
    end
  end
end
