require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "immutable" do
    user = User.create(username: "Uncategorized", password: "password")
    category, subcategory = user.Uncategorized
    
    assert_equal(false, category.update(name: "something_else"))
    assert_equal(false, category.destroy!)
  end
end
