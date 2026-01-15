require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips username" do
    user = User.new(username: " USERNAME ")
    assert_equal("username", user.username)
  end

  test "create uuid before validation" do
    user = User.create(username: "create_uuid", password: "password")
    assert_not_equal(nil, user.uuid)
    assert_not_equal(nil, user.access_token)
  end

  test "create Uncategorized category/subcategory" do
    user = User.create(username: "Uncategorized", password: "password")
    assert_equal(1, user.categories.count)
    assert_equal(1, user.subcategories.count)
    assert_equal("Uncategorized", user.categories.first.name)
    assert_equal("Uncategorized", user.subcategories.first.name)

    category, subcategory = user.uncategorized
    assert_equal(user.categories.first, category)
    assert_equal(user.subcategories.first, subcategory)
  end

  test "regenerate access token" do
    user = User.create(username: "create_uuid", password: "password")
    user.regenerate_token
    previous_token = user.access_token
    user.regenerate_token
    assert user.access_token != previous_token
  end

  test "username uniqueness" do
    one = users(:one)
    user = User.new(username: one.username)
    assert_equal false, user.save
    assert user.errors.full_messages.include? "Username can't be used"
  end
end
