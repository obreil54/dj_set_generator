require "test_helper"

class PlaylistTest < ActiveSupport::TestCase
  def setup
    @user = users(:ilya)
    @other_user = users(:premier)
  end

  test "valid playlist should be valid" do
    playlist = Playlist.new(name: "Test Playlist", user: @user)
    assert playlist.valid?
  end

  test "invalid without name" do
    playlist = Playlist.new(user: @user)
    assert_not playlist.valid?, "Playlist should be invalid without name"
  end

  test "invalid without user" do
    playlist = Playlist.new(name: "Test Playlist")
    assert_not playlist.valid?, "Playlist should be invalid without user"
  end

  test "does not allow duplicate playlist names for the same user" do
    Playlist.create!(name: "Test Playlist", user: @user)
    playlist = Playlist.new(name: "Test Playlist", user: @user)

    assert_not playlist.valid?, "User should not have duplicate playlist names"
  end

  test "allows duplicate playlist names for different users" do
    Playlist.create!(name: "Test Playlist", user: @user)
    playlist = Playlist.new(name: "Test Playlist", user: @other_user)

    assert playlist.valid?, "Different users should be able to use the same playlist name"
  end
end
