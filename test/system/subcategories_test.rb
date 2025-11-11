require "application_system_test_case"

class SubcategoriesTest < ApplicationSystemTestCase
  setup do
    login_as(users(:one))
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

    assert_content "Subcategory was successfully created"
  end

  test "should update Subcategory" do
    visit category_subcategory_url(@subcategory.category, @subcategory)
    click_on "Edit this sub-category", match: :first

    fill_in "Name", with: @subcategory.name
    fill_in "Description", with: @subcategory.description
    click_on "Save"

    assert_content "Subcategory was successfully updated"
  end

  test "should edit Subcategory's expenses" do
    visit category_subcategory_url(@subcategory.category, @subcategory)
    within("table.table-striped") do
      find_button(match: :first).click
    end
    check("expense_ignore", visible: false)
    click_on "Save changes", visible: false

    assert_content "Expense was successfully updated"
    #assert_equal([], page.driver.browser.logs.get(:browser))
  end

  test "should destroy Subcategory" do
    visit category_subcategory_url(@subcategory.category, @subcategory)
    click_on "Delete this sub-category"

    assert_text "Yes, delete this sub-category"
    click_on "Yes, delete this sub-category"    
  end

  test "should transfer Subcategory" do
    visit category_subcategory_url(@subcategory.category, @subcategory)
    all("input[type=checkbox]").each do |checkbox|
      checkbox.check
    end
    click_on "Transfer"

    select(@subcategory.category.name, from: "category_id", visible: false)
    select(@subcategory.name, from: "subcategory_id", visible: false)
    click_on "Save", visible: false

    assert_content "Expenses were successfully transfered"
  end
end
