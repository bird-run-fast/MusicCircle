class Room < ApplicationRecord
  # アソシエーション部分
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  # roomsテーブルから(中間てーぶるを介した)endusersテーブルへの関連付け
  has_many :endusers, through: :entries

  # バリデーション部分
  
end
