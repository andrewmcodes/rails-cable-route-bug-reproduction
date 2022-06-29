require "test_helper"

class TestControllerTest < ActionDispatch::IntegrationTest
  # Fails
  test "route prefixed with 'cable-' should get index" do
    get cable_hyphenated_slug_path
    assert response.ok?
  end

  # Succeeds
  test "route prefixed with 'cable_' should get index" do
    get cable_underscored_slug_path
    assert response.ok?
  end
end
