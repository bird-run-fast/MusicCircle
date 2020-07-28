class Concern < ApplicationRecord
  belongs_to :enduser
  belongs_to :post
  validates :enduser_id, uniqueness: { scope: :post_id } # 追加
end
