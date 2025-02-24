require "application_system_test_case"

class AvatarUpdatesTest < ApplicationSystemTestCase
  setup do
   login_user
  end

  test "user can update their avatar via turbo frame" do
    visit user_path(@user)

    assert_selector "#profile-avatar"
    assert_selector "a", text: "Edit Avatar"

    click_on "Edit Avatar"

    assert_selector "turbo-frame#avatar_form"

    attach_file "user[profile_picture]", Rails.root.join("test/fixtures/files/profile_pic.png")
    click_on "Update Avatar"

    assert_no_selector "turbo-frame#avatar_form"
    assert_selector "#profile-avatar[src*='profile_pic.png']"
  end
end
