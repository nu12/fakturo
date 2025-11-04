require "test_helper"

class SubcategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
    @subcategory = subcategories(:one)
  end

  test "should get index" do
    get category_subcategories_url(@subcategory.category)
    assert_response :success
  end

  test "should get new" do
    get new_category_subcategory_url(@subcategory.category)
    assert_response :success
  end

  test "should create subcategory" do
    assert_difference("Subcategory.count") do
      post category_subcategories_url(@subcategory.category), params: { subcategory: { category_id: @subcategory.category_id, name: @subcategory.name } }
    end

    assert_redirected_to category_subcategories_url(@subcategory.category)
  end

  test "should show subcategory" do
    get category_subcategory_url(@subcategory.category, @subcategory)
    assert_response :success
  end

  test "should get edit" do
    get edit_category_subcategory_url(@subcategory.category, @subcategory)
    assert_response :success
  end

  test "should update subcategory" do
    patch category_subcategory_url(@subcategory.category, @subcategory), params: { subcategory: { category_id: @subcategory.category_id, name: @subcategory.name } }
    assert_redirected_to category_subcategory_url(@subcategory)
  end

  test "should destroy subcategory" do
    assert_difference("Subcategory.count", -1) do
      delete category_subcategory_url(@subcategory.category, @subcategory)
    end

    assert_redirected_to category_subcategories_url
  end

  test "should transfer subcategory" do
    post subcategories_transfer_url, params: { selected: "1", subcategory_id: @subcategory.id }
    assert_response :see_other
    assert_redirected_to category_subcategory_url(@subcategory.category, @subcategory)
  end
end
