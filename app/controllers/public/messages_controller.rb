class Public::MessagesController < ApplicationController
  before_action :authenticate_enduser!
  def create
    if Entry.where(:enduser_id => current_enduser.id, :room_id => params[:message][:room_id]).present?
      @message = Message.create(params.require(:message).permit(:enduser_id, :content, :room_id).merge(:enduser_id => current_enduser.id))
      redirect_to public_room_path(@message.room_id)
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
