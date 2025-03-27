class PlaylistTrack < ApplicationRecord
  belongs_to :playlist
  belongs_to :track
  validates :position, presence: true
  validates :position, uniqueness: {scope: :playlist_id, message: "This position is already taken"}
  validates :track_id, uniqueness: {scope: :playlist_id, message: "This track is already in the playlist"}
end
