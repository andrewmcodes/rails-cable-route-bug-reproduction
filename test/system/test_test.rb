require "application_system_test_case"

class TestTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_url

    assert_no_selector "pre", text: "Page not found"
    assert_selector "h1", text: "TestController#index"
  end

  # Broken test to verify the behavior of the application.
  test "visiting the hyphenated path prefixed with cable" do
    visit cable_hyphenated_slug_path

    assert_no_selector "pre", text: "Page not found"
    assert_selector "h1", text: "TestController#index"
  end

  test "visiting the underscored path prefixed with cable" do
    visit cable_underscored_slug_path

    assert_no_selector "pre", text: "Page not found"
    assert_selector "h1", text: "TestController#index"
  end

  test "visiting the underscored then hyphenated path prefixed with cable" do
    visit cable_mixed_slug_path

    assert_no_selector "pre", text: "Page not found"
    assert_selector "h1", text: "TestController#index"
  end
end
