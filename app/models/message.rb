class Message < ApplicationRecord
  # アソシエーション部分
  belongs_to :enduser
  belongs_to :room
  has_many :notifications, dependent: :destroy

  # バリデーション部分
  validates :content, presence: true
end
