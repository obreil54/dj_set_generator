require "test_helper"

class PlaylistTrackTest < ActiveSupport::TestCase
  setup do
    @playlist = playlists(:test_playlist)
    @track = tracks(:dr_birds)
    @other_track = tracks(:jpegultra)
  end

  test "valid playlist track should be valid" do
    playlist = PlaylistTrack.new(playlist: @playlist, track: @track, position: 2)
    assert playlist.valid?
  end

  test "playlist track should be invalid without playlist" do
    playlist = PlaylistTrack.new(track: @track, position: 2)
    assert playlist.invalid?
  end

  test "playlist track should be invalid without track" do
    playlist = PlaylistTrack.new(playlist: @playlist, position: 2)
    assert playlist.invalid?
  end

  test "playlist track should be invalid without position" do
    playlist = PlaylistTrack.new(playlist: @playlist, track: @track)
    assert playlist.invalid?
  end

  test "playlist track should be invalid with duplicate position within a playlist" do
    PlaylistTrack.create(playlist: @playlist, track: @track, position: 2)
    playlist = PlaylistTrack.new(playlist: @playlist, track: @other_track, position: 2)
    assert playlist.invalid?
  end

  test "playlist track should be invalid with duplicate track" do
    PlaylistTrack.create(playlist: @playlist, track: @track, position: 2)
    playlist = PlaylistTrack.new(playlist: @playlist, track: @track, position: 3)
    assert playlist.invalid?
  end
end
