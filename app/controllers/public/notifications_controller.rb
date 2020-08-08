class Public::NotificationsController < ApplicationController
  def index
    @notifications = current_enduser.passive_notifications.includes([:visitor,:visited, :post]).page(params[:page]).per(20)
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end
end
