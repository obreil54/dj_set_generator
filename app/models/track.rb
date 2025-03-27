class Track < ApplicationRecord
  validates :name, :artist, :genre, :spotify_link, :release_year, :bpm, :key, :open_key, :danceability, presence: true

  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks
end
