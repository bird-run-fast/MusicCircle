class Message < ApplicationRecord
  belongs_to :enduser
  belongs_to :room
end
