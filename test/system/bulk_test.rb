require "application_system_test_case"

class BulkTest < ApplicationSystemTestCase
  setup do
    login_as(users(:one))
    @subcategory = subcategories(:one)
  end

  test "should transfer expenses" do
    visit category_subcategory_url(@subcategory.category, @subcategory)
    all("input[type=checkbox]").each do |checkbox|
      checkbox.check
    end
    within("table.table-striped thead") do
      find_button(match: :first).click
    end
    click_on "Transfer", visible: false

    select(@subcategory.category.name, from: "category_id", visible: false)
    select(@subcategory.name, from: "subcategory_id", visible: false)
    click_on "Transfer selected", visible: false

    assert_content "Expenses were successfully transfered"
  end

  test "should delete expenses" do
    visit category_subcategory_url(@subcategory.category, @subcategory)
    all("input[type=checkbox]").each do |checkbox|
      checkbox.check
    end
    within("table.table-striped thead") do
      find_button(match: :first).click
    end
    within("div#accordionExpenses div.accordion-item:nth-child(2) h2.accordion-header", visible: false) do
      find_button(match: :first, visible: false).click
    end
    click_on "Delete selected", visible: false

    assert_content "Expenses were successfully destroyed"
  end
end
