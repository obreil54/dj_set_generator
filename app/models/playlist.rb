class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks

  validates :name, presence: true
  validates :name, uniqueness: {scope: :user_id, message: "You already have a playlist with this name"}
end
