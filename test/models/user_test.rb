require "test_helper"

class UserTest < ActiveSupport::TestCase
  def build_user(overrides = {})
    User.new({
      first_name: "Test",
      last_name: "User",
      username: "testuser",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123"
    }.merge(overrides))
  end

  test "valid user should be valid" do
    user = build_user
    assert user.valid?
  end

  test "invalid without required user attributes" do
    [:first_name, :last_name, :username].each do |attr|
      user = build_user(attr => nil)
      refute user.valid?, "User should be invalid without #{attr}"
      assert_includes user.errors[attr], "can't be blank", "Expected an error on #{attr}, but got none"
    end
  end

  test "invalid without email" do
    user = build_user(email: nil)
    refute user.valid?, "User should be invalid without email"
    assert_includes user.errors[:email], "can't be blank", "Expected an error on email, but got none"
  end

  test "invalid without password" do
    user = build_user(password: nil)
    refute user.valid?, "User should be invalid without password"
    assert_includes user.errors[:password], "can't be blank", "Expected an error on password, but got none"
  end


  test "username and email must be unique" do
    user = build_user
    assert user.save, "User should save successfully before uniqueness test"

    [:username, :email].each do |attr|
      duplicate_user = build_user(attr => user.send(attr))
      duplicate_user.username = "differentusername" if attr == :email

      refute duplicate_user.valid?, "Expected duplicate #{attr} to be invalid"
      assert_not_nil duplicate_user.errors[attr], "Expected uniqueness validation error on #{attr}"
    end
  end

  test "invalid with improperly formatted email" do
    invalid_emails = ["plainaddress", "missing_at.com", "user@example", "user@.com", "user@example,com", "user@example..com"]
    invalid_emails.each do |invalid_email|
      user = build_user(email: invalid_email)
      refute user.valid?, "#{invalid_email.inspect} should be invalid"
      assert_not_nil user.errors[:email], "Expected an error on email for #{invalid_email.inspect}"
    end
  end

  test "invalid if password too short" do
    user = build_user(password: "12345", password_confirmation: "12345")
    refute user.valid?, "Password should be invalid if too short"
    assert_not_nil user.errors[:password], "Expected a validation error on password"
  end

  test "avatar should return uploaded profile picture if present" do
    user = build_user
    user.profile_picture.attach(io: File.open(Rails.root.join("test/fixtures/files/profile_pic.png")), filename: "profile_pic.png", content_type: "image/png")
    user.save!

    assert user.avatar.present?, "Expected avatar to return an image"
    assert_match /rails\/active_storage\/blobs/, user.avatar, "Expected avatar to return an uploaded profile picture URL"
  end

  test "avatar should return default image if no profile picture" do
    user = build_user

    expected_path = ActionController::Base.helpers.asset_path("default_avatar.png")
    assert_equal expected_path, user.avatar, "Expected avatar to return default image when no profile picture is uploaded"
  end
end
