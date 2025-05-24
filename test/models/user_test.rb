require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  # Associations
  test "should have many posts" do
    assert_respond_to @user, :posts
  end

#   test "should have many comments" do
#     assert_respond_to @user, :comments
#   end

#   # Validations
#   test "should be invalid without a name" do
#     @user.name = nil
#     assert_not @user.valid?
#     assert_includes @user.errors[:name], "can't be blank"
#   end

#   test "should be invalid without an email" do
#     @user.email = nil
#     assert_not @user.valid?
#     assert_includes @user.errors[:email], "can't be blank"
#   end

#   test "should validate uniqueness of email" do
#     @user.save!
#     another_user = @user.dup
#     another_user.email = @user.email.upcase
#     assert_not another_user.valid?
#     assert_includes another_user.errors[:email], "has already been taken"
#   end

#   test "should require password" do
#     @user.password = nil
#     @user.password_confirmation = nil
#     assert_not @user.valid?
#     assert_includes @user.errors[:password], "can't be blank"
#   end

#   test "should validate password length" do
#     @user.password = @user.password_confirmation = "123"
#     assert_not @user.valid?
#     assert_includes @user.errors[:password], "is too short (minimum is 6 characters)"
#   end

#   # has_secure_password check
#   test "should authenticate with correct password" do
#     @user.save!
#     assert @user.authenticate("password")
#   end

#   test "should not authenticate with incorrect password" do
#     @user.save!
#     assert_not @user.authenticate("wrongpassword")
#   end
end
