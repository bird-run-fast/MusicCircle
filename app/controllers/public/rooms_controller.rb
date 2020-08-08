class Public::RoomsController < ApplicationController
  def create
    @room = Room.create
    # @entry1でdmを送る側,@entry2でdmを送られる側の設定をそれぞれ行う
    @entry1 = Entry.create(room_id: @room.id, enduser_id: current_enduser.id)
    # permit()内について, :enduser_id はフォームから送られてきたもの,:room_idはmergeで設定した@room.id
    @entry2 = Entry.create(params.require(:entry).permit(:enduser_id, :room_id).merge(:room_id => @room.id))
    redirect_to public_room_path(@room.id)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(:enduser_id => current_enduser.id, :room_id => @room.id).present?
      # メッセージ一覧の表示部分
      @messages = @room.messages.includes(:enduser)
      @message = Message.new
      @entries = @room.entries.includes(:enduser)
      # メッセージ一覧の表示部分ここまで

      # チャット相手一覧の表示部分。以下1~4は手順。
      # - 1.ログインしているユーザに紐づくroomsのIDを取得。(@roomIds)
      # - 2.チャットしたことある相手知りたい　→　ログインユーザーに紐づくroomに紐づいてる２ユーザーのうち自分でないほうを検索(@entryUser)
      # - 3.最新のメッセージ内容を表示したい　→　ログインユーザーに紐づくroomに紐づいているメッセージのうち一番最後のものを取得(@entrymessage)
      # - 4.それらを配列の形でまとめて保持しビューに渡す(@combで一回のループごとまとめて,さらにそれを@combsで二次配列にしてまとめている)

      # 手順1
      @roomIds = current_enduser.rooms.pluck(:id)
      @combs = []
      @roomIds.each do |roomId|
        # 手順2
        @entryUser = Room.find(roomId).endusers.where.not(id: current_enduser)
        # 手順3
        @entrymessage = Message.where(room_id: roomId).last
        # 手順4　(@combs=[]はループの前に出してる)
        @comb = []
        @comb.push(@entryUser, @entrymessage)
        @combs.push(@comb)
      end
      # なぜかこの記述だと@combs[0][0][0]に最初の@entryUserが入り、combs[0][1]に最初の@messageが入る
      # @combs[0][0]がactiveRecordsの値なのでrailsの使用上の問題?　後でメンターに聞く。
      # チャット相手一覧の表示部分ここまで

    else
      redirect_back(fallback_location: root_path)
    end
  end
end
