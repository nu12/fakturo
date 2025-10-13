require "application_system_test_case"

class DocumentsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:one)
    @document = documents(:one)
  end

  test "visiting the index" do
    visit documents_url
    assert_selector "h1", text: "Documents"
  end

  test "should create document" do
    visit documents_url
    click_on "New Document"

    fill_in "Name", with: @document.name
    select(@document.year, from: 'document_year')
    select(@document.month, from: 'document_month')
    select(@document.source.name, from: 'document_source_id')
    click_on "Save"

    assert_text "Document was successfully created"
    click_on "Documents"
  end

  test "should update Document" do
    visit document_url(@document)
    click_on "Edit this document", match: :first

    fill_in "Name", with: @document.name
    select(@document.year, from: 'document_year')
    select(@document.month, from: 'document_month')
    select(@document.source.name, from: 'document_source_id')
    click_on "Save"

    assert_text "Document was successfully updated"
    click_on "Documents"
  end

  test "should destroy Document" do
    visit document_url(@document)
    click_on "Delete this document"
    
    assert_text "Yes, delete this document"
    click_on "Yes, delete this document"
  end
end
