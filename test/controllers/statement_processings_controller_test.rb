require "test_helper"

class StatementProcessingsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:one) }
  test "should schedule retry" do
    sp = statements(:upload).statement_processing
    sp.statement.file.attach(
      io: File.open("test/fixtures/files/faktura.pdf"),
      filename: "faktura.pdf",
      content_type: "application/pdf"
    )
    sp.update(has_succeeded: false)
    patch statement_processing_url sp
    assert_response :found
    assert_redirected_to statement_url(sp.statement)

    follow_redirect!
    assert_notice "Processing was successfully rescheduled"
  end

  test "should not schedule completed processing" do
    sp = statements(:upload).statement_processing
    sp.statement.file.attach(
      io: File.open("test/fixtures/files/faktura.pdf"),
      filename: "faktura.pdf",
      content_type: "application/pdf"
    )
    sp.update(has_succeeded: true)
    patch statement_processing_url sp
    assert_response :see_other
    assert_redirected_to statement_url(sp.statement)

    follow_redirect!
    assert_notice "Statement has already been sucessfully processed"
  end

  test "should not schedule deleted file" do
    sp = statements(:upload).statement_processing
    sp.update(has_succeeded: false)
    patch statement_processing_url sp
    assert_response :see_other
    assert_redirected_to statement_url(sp.statement)

    follow_redirect!
    assert_notice "Statement file has already been deleted"
  end

  private
    def assert_notice(text)
      assert_select "div", /#{text}/
    end
end
