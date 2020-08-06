class Comment < ApplicationRecord
  belongs_to :enduser
  belongs_to :post
  has_many :notifications, dependent: :destroy
end
