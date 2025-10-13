require "application_system_test_case"

class SubcategoriesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:one)
    @subcategory = subcategories(:one)
  end

  test "visiting the index" do
    visit category_subcategories_url(@subcategory.category)
    assert_selector "h1", text: "Sub-categories"
  end

  test "should create subcategory" do
    visit category_subcategories_url(@subcategory.category)
    click_on "New Sub-category"

    fill_in "Name", with: @subcategory.name
    fill_in "Description", with: @subcategory.description
    click_on "Save"

    assert_text "Subcategory was successfully created"
    click_on @subcategory.category.name
  end

  test "should update Subcategory" do
    visit category_subcategory_url(@subcategory.category, @subcategory)
    click_on "Edit this sub-category", match: :first

    fill_in "Name", with: @subcategory.name
    fill_in "Description", with: @subcategory.description
    click_on "Save"

    assert_text "Subcategory was successfully updated"
    click_on "Sub-categories"
  end

  test "should access Sub-category's expenses" do
    visit category_subcategory_url(@subcategory.category, @subcategory)
    click_on "Expenses", match: :first
    click_on "Show", match: :first

    assert_text @subcategory.name
    click_on @subcategory.name
  end

  test "should destroy Subcategory" do
    visit category_subcategory_url(@subcategory.category, @subcategory)
    click_on "Delete this sub-category"

    assert_text "Yes, delete this sub-category"
    click_on "Yes, delete this sub-category"
  end
end
