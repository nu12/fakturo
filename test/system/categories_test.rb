require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:one)
    @category = categories(:one)
  end

  test "visiting the index" do
    visit categories_url
    assert_selector "h1", text: "Categories"
  end

  test "should create category" do
    visit categories_url
    click_on "New Category"

    fill_in "Name", with: @category.name
    fill_in "Description", with: @category.description
    click_on "Save"

    assert_text "Category was successfully created"
    click_on "Categories"
  end

  test "should update Category" do
    visit category_url(@category)
    click_on "Edit", match: :first

    fill_in "Name", with: @category.name
    fill_in "Description", with: @category.description
    click_on "Save"

    assert_text "Category was successfully updated"
    click_on "Categories"
  end

  test "should edit Category's expenses" do
    visit category_url(@category)
    within("table.table-striped") do
      find_button.click
    end
    check("expense_ignore", visible: false)
    click_on "Save changes", visible: false

    assert_text @category.name
  end

  test "should destroy Category" do
    visit category_url(@category)
    click_on "Delete this category"

    assert_text "Yes, delete this category"
    click_on "Yes, delete this category"
  end
end
