require "test_helper"

class UrlValidatorTest < ActionDispatch::IntegrationTest
  test "url_valid? success with http" do
    assert UrlValidator.string_valid?("http://42.fr")
  end

  test "url_valid? success with https" do
    assert UrlValidator.string_valid?("https://42.fr/")
  end

  test "url_valid? failed" do
    assert_not UrlValidator.string_valid?("https//42.fr/")
  end
end
