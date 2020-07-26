class Tag < ApplicationRecord
  # tagテーブルからpost_tag(中間テーブル)に対する関連付け
  has_many :post_tags, dependent: :destroy
  # tagテーブルから(中間てーぶるを介した)postsテーブルへの関連付け
  has_many :posts, through: :post_tags
end
