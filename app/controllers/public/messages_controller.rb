class Public::MessagesController < ApplicationController
  before_action :authenticate_enduser!
  def create
    # paramsで送られてきたroomにログインユーザが所属している確認し、所属が確認できればmessageのcreateを行う。
    if Entry.where(:enduser_id => current_enduser.id, :room_id => params[:message][:room_id]).present?
      @message = Message.create(params.require(:message).permit(:enduser_id, :content, :room_id).merge(:enduser_id => current_enduser.id))
      # 下のvisitedIdはnotificationに渡すvisited_id用の変数
      # 作成したメッセージが所属しているroomに紐づく2ユーザー(1:1チャットなので2ユーザー)のうち、自分でないほうのユーザーのidを取得したもの
      # .endusersで多数のアソシエショーンを持ってきたり、.whereで複数の値をもってきたりすると配列型になるためインデックス番号0を指定
      visitedId = Room.find(params[:message][:room_id]).endusers.where.not(id: current_enduser.id)[0].id
      notification = Notification.create(visitor_id: current_enduser.id,visited_id: visitedId,message_id: @message.id,action: "message")
      redirect_to public_room_path(@message.room_id)
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
