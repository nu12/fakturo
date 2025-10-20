require "application_system_test_case"

class SourcesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:one)
    @source = sources(:one)
  end

  test "visiting the index" do
    visit sources_url
    assert_selector "h1", text: "Sources"
  end

  test "should create source" do
    visit sources_url
    click_on "New Source"

    fill_in "Name", with: @source.name
    click_on "Save"

    assert_text "Source was successfully created"
    click_on "Sources"
  end

  test "should update Source" do
    visit source_url(@source)
    click_on "Edit this source", match: :first

    fill_in "Name", with: @source.name
    click_on "Save"

    assert_text "Source was successfully updated"
    click_on "Sources"
  end

  test "should edit Source's expenses" do
    visit source_url(@source)
    within("table.table-striped") do
      find_button.click
    end
    check("expense_ignore", visible: false)
    click_on "Save changes", visible: false

    assert_text @source.name
  end

  test "should destroy Source" do
    visit source_url(@source)
    click_on "Delete this source"

    assert_text "Yes, delete this source"
    click_on "Yes, delete this source"
  end
end
