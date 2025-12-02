require "test_helper"

class SubcategoryTest < ActiveSupport::TestCase
  test "immutable" do
    user = User.create(username: "Uncategorized", password: "password")
    category, subcategory = user.Uncategorized
    
    assert_equal(false, subcategory.update(name: "something_else"))
    assert_equal(false, subcategory.destroy!)
  end
end
