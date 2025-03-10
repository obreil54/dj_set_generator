class Playlist < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: {scope: :user_id, message: "You already have a playlist with this name"}
end
