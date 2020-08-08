class Comment < ApplicationRecord
  # アソシエーション部分
  belongs_to :enduser
  belongs_to :post
  has_many :notifications, dependent: :destroy

  # バリデーション部分
  validates :content, presence: true
end
