class Message < ApplicationRecord
  belongs_to :enduser
  belongs_to :room
  has_many :notifications, dependent: :destroy
end
