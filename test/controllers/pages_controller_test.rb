require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "route prefixed with 'cable-' should get index" do
    get "/cable-hyphenated-slug"
    assert response.ok?
  end

  test "route prefixed with 'cable_' should get index" do
    get "/cable_underscored_slug"
    assert response.ok?
  end
end
