class Track < ApplicationRecord
  validates :name, :artist, :genre, :spotify_link, :release_year, :bpm, :key, :open_key, :danceability, presence: true
end
