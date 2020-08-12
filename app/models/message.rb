class Message < ApplicationRecord
  # アソシエーション部分
  belongs_to :enduser
  belongs_to :room
  has_many :notifications, dependent: :destroy

  # バリデーション部分
  validates :content, presence: true

  def create_notificaton_dm(current_enduser)
    notification = current_enduser.active_notifications.new(message_id: id, visited_id: enduser_id, action: 'message')
    notification.save
  end
  
end
