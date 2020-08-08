class Concern < ApplicationRecord
  # アソシエーション部分
  belongs_to :enduser
  belongs_to :post

  # バリデーション部分
  validates :enduser_id, uniqueness: { scope: :post_id }
end
