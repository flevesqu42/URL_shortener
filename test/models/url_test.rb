require "test_helper"

class UrlTest < ActiveSupport::TestCase
  test "should succeeded with valid attributes" do
    url = Url.new(full_url: "http://test.42.fr")
    assert url.save
  end

  test "should succeeded with spaces attributes" do
    url = Url.new(full_url: "   http://test.42.fr  ")
    assert url.save
  end

  test "should failed without attribute" do
    url = Url.new
    assert_not url.save
  end

  test "should failed if already inserted" do
    url = Url.new(full_url: "   http://test.42.fr  ")
    assert url.save
    url = Url.new(full_url: "http://test.42.fr")
    assert_not url.save
  end

  test "should failed if already inserted event with space attributes" do
    url = Url.new(full_url: "http://test.42.fr")
    assert url.save
    url = Url.new(full_url: "   http://test.42.fr  ")
    assert_not url.save
  end

  test "ID can't be set by user with attributes" do
    url = Url.new(id: "ABC", full_url: "http://test.42.fr")
    assert url.save
    assert_not_equal url.id, "ABC"
  end

  test "ID is URL friendly" do
    url = Url.new(full_url: "http://test.42.fr")
    assert url.save

    len = url.id.length
    assert len >= 6 && len <= 10

    # letter is URL-Friendly
    (0...len).each do |j|
      refute_nil Nanoid::SAFE_ALPHABET.index(url.id[j])
    end
  end
end
