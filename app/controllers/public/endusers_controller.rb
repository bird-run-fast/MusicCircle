class Public::EndusersController < ApplicationController
  before_action :authenticate_enduser!
  def show
    @posts = current_enduser.posts.includes([:post_tags, :tags])
  end

  def dmshow
    @posts = current_enduser.posts.includes([:post_tags, :tags])
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
      @entryUser = Room.find(roomId).endusers.where.not(id: current_enduser).first
      # 手順3
      @entrymessage = Message.where(room_id: roomId).last
      # 手順4　(@combs=[]はループの前に出してる)
      @comb = []
      @comb.push(@entryUser, @entrymessage,roomId)
      @combs.push(@comb)
    end
  end

  def edit
  end

  def update
    @enduser = current_enduser
    @enduser.update!(enduser_params)
    redirect_to public_endusers_path(@enduser), notice: "登録情報の編集に成功しました"
  # 以下は例外処理の実行文。
  # アプリ試してもらったほとんどの人はエラー起きなかったが、たまに画像アップロードを使用した際たまにtextfilebusyのエラーがおきる
  # ９割方の人は問題なく使えており原因の特定が難しい(恐らく使用しているセキュリティーソフト等の関係 + windows使用の関係？)ため、
  # とりあえずエラーが起きたらnotice文を出してユーザーにエラーを伝え、もう一度画像アップロードをしてもらう(何回か試すと成功するため)。
  rescue => e
    pp e
    flash.now[:notice] = "画像の更新に失敗しました"
    render :edit
  end

  private
  def enduser_params
    params.require(:enduser).permit(:name, :email, :introduction, :area, :age, :image)
  end
end
