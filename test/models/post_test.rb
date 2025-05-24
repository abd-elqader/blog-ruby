require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:one) || User.create!(name: "Test User", email: "test@example.com", password: "password")
    @post = Post.new(title: "Sample Post", body: "This is a post body", author: @user)
    @post.tags << tags(:one) if defined?(tags) && tags(:one) # assumes fixtures
  end

  # Associations
  test "should belong to author" do
    assert_equal @user, @post.author
  end

  test "should have many comments" do
    assert_respond_to @post, :comments
  end

  test "should have many post_tags" do
    assert_respond_to @post, :post_tags
  end

  test "should have many tags through post_tags" do
    assert_respond_to @post, :tags
  end

  # Validations
  test "should not save without title" do
    @post.title = nil
    assert_not @post.valid?
    assert_includes @post.errors[:title], "can't be blank"
  end

  test "should not save without body" do
    @post.body = nil
    assert_not @post.valid?
    assert_includes @post.errors[:body], "can't be blank"
  end

  # Custom validation
  test "should not be valid without tags" do
    @post.tags.clear
    assert_not @post.valid?
    assert_includes @post.errors[:tags], "must have at least one tag"
  end

  # Callback test
  test "should schedule deletion after creation" do
    PostDeletionWorker.expects(:perform_in).with(24.hours, kind_of(Integer))
    @post.save!
  end
end
