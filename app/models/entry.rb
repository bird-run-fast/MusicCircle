class Entry < ApplicationRecord
  # アソシエーション部分
  belongs_to :enduser
  belongs_to :room

  # バリデーション部分
end
