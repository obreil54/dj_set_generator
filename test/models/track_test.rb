require "test_helper"

class TrackTest < ActiveSupport::TestCase
  def build_track(overrides = {})
    Track.new({
      name: "Test Song",
      artist: "Test Artist",
      genre: "Pop",
      spotify_link: "https://open.spotify.com/track/7qiZfU4dY1lWllzX7mPBI3",
      release_year: 2017,
      bpm: 96,
      key: "A",
      open_key: "11B",
      danceability: 0.825
    }.merge(overrides))
  end

  test "valid track should be valid" do
    track = build_track
    assert track.valid?
  end

  test "invalid without required track attributes" do
    [:name, :artist, :genre, :spotify_link, :release_year, :bpm, :key, :open_key, :danceability].each do |attr|
      track = build_track(attr => nil)
      refute track.valid?, "Track should be invalid without #{attr}"
      assert_includes track.errors[attr], "can't be blank", "Expected an error on #{attr}, but got none"
    end
  end
end
