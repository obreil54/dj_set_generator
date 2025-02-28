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

  test "user cannot update avatar without selecting a file" do
    visit user_path(@user)

    click_on "Edit Avatar"

    assert_selector "turbo-frame#avatar_form"

    click_on "Update Avatar"

    assert_selector "turbo-frame#avatar_form"
    assert_text "Please select an image before updating"
  end

  test "image preview updates when selecting a file" do
    visit user_path(@user)

    click_on "Edit Avatar"

    assert_selector "#avatar-preview"

    original_src = find("#avatar-preview")[:src]

    attach_file "user[profile_picture]", Rails.root.join("test/fixtures/files/profile_pic.png")

    new_src = find("#avatar-preview")[:src]

    refute_equal original_src, new_src, "Avatar preview did not update as expected"
  end

  test "user can manually close avatar edit form" do
    visit user_path(@user)

    click_on "Edit Avatar"
    assert_selector "turbo-frame#avatar_form"

    click_on "✖"

    assert_no_selector "turbo-frame#avatar_form"
  end
end
