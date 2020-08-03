class Entry < ApplicationRecord
  belongs_to :enduser
  belongs_to :room
end
