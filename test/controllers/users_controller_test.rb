require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:ilya)
    @user = users(:ilya)
  end

  test "should update avatar when valid image is uploaded" do
    file = fixture_file_upload(Rails.root.join("test/fixtures/files/profile_pic.png"), "image/png")

    patch update_avatar_user_path(@user), params: {user: {profile_picture: file}}, as: :turbo_stream

    assert_response :success
    assert @user.reload.profile_picture.attached?, "Profile picture should be attached"
  end

  test "should not update avatar when no image is uploaded" do
    patch update_avatar_user_path(@user), params: {user: {profile_picture: nil}}, as: :turbo_stream

    assert_response :unprocessable_entity
    assert_not @user.reload.profile_picture.attached?, "Profile picture should not be attached"
  end
end
