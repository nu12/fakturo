require "application_system_test_case"

class StatementsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:one)
    @statement = statements(:one)
  end

  test "visiting the index" do
    visit statements_url
    assert_selector "h1", text: "Statements"
  end

  test "should create statement" do
    visit statements_url
    click_on "New Statement"

    select(@statement.year, from: "statement_year")
    select(@statement.month, from: "statement_month")
    select(@statement.source.name, from: "statement_source_id")
    click_on "Save"

    assert_text "Statement was successfully created"
    click_on "Statements"
  end

  test "should update statement" do
    visit statement_url(@statement)
    click_on "Edit this statement", match: :first

    select(@statement.year, from: "statement_year")
    select(@statement.month, from: "statement_month")
    select(@statement.source.name, from: "statement_source_id")
    click_on "Save"

    assert_text "Statement was successfully updated"
    click_on "Statements"
  end

  test "should destroy Statement" do
    visit statement_url(@statement)
    click_on "Delete this statement"

    assert_text "Yes, delete this statement"
    click_on "Yes, delete this statement"
  end
end
