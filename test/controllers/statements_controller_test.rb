require "test_helper"

class StatementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
    @statement = statements(:one)
  end

  test "should get index" do
    get statements_url
    assert_response :success
  end

  test "should get new" do
    get new_statement_url
    assert_response :success
  end

  test "should create statement" do
    assert_difference("Statement.count") do
      post statements_url, params: { statement: { date: "2025-03-10", source_id: @statement.source.id } }
    end

    assert_redirected_to statement_url(Statement.last)
  end

  test "should create statement with file upload" do
    file = fixture_file_upload("faktura.pdf", "application/pdf")
    assert_difference("Statement.count") do
      post statements_url, params: { statement: { date: "2025-03-12", file: file, source_id: @statement.source.id } }
    end

    assert_redirected_to statement_url(Statement.last)
    assert_response :found
  end

  test "should create statement processing with file upload" do
    file = fixture_file_upload("faktura.pdf", "application/pdf")
    assert_difference("StatementProcessing.count") do
      post statements_url, params: { statement: { date: "2025-03-12", file: file, source_id: @statement.source.id } }
    end
  end

  test "should show statement" do
    get statement_url(@statement)
    assert_response :success
  end

  test "should get edit" do
    get edit_statement_url(@statement)
    assert_response :success
  end

  test "should update statement" do
    patch statement_url(@statement), params: { statement: { month: @statement.month, source_id: @statement.source_id, year: @statement.year } }
    assert_redirected_to statement_url(@statement)
  end

  test "should destroy statement" do
    assert_difference("Statement.count", -1) do
      delete statement_url(@statement)
    end

    assert_redirected_to statements_url
  end
end
