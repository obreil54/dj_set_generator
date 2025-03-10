class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_one_attached :profile_picture

  validates :username, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true

  has_many :playlists, dependent: :destroy

  def avatar
    if profile_picture.attached?
      Rails.application.routes.url_helpers.rails_blob_path(profile_picture, only_path: true)
    else
      ActionController::Base.helpers.asset_path("default_avatar.png")
    end
  end
end
