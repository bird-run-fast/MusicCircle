class Post < ApplicationRecord
  
  belongs_to :enduser
  has_many :concerns
  has_many :concern_endusers, through: :concerns, source: :enduser
  has_many :post_tags, dependent: :destroy# postテーブルからpost_tag(中間テーブル)に対する関連付け
  has_many :tags, through: :post_tags# postテーブルから(中間てーぶるを介した)tagsテーブルへの関連付け
  has_many :comments, dependent: :destroy

  enum is_valid: {募集中:0, 募集終了:1}

  def concerned_by?(enduser)
    concerns.where(enduser_id: enduser.id).exists?
  end
end
