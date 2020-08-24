class Public::EndusersController < ApplicationController
  before_action :authenticate_enduser!
  def show
    @posts = current_enduser.posts.includes([:post_tags, :tags]).page(params[:page]).per(10)
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

  # chartアクションは気になる数、コメント数を集計してグラフ表示するアクション
  # gem 'chartkick'を使用しており、@concerns_weekのように二重配列の形で、子の配列の[0]にグラフのx軸の値,[1]にy軸の値が入れたものを用意しておけば、view側でgemのメソッドを用いてグラフを描画できる。
  def chart
        now = Time.current
        # c で current_enduser の投稿が何日に何個良いねされたかを集計している。{"2020-07-28"=>4, "2020-08-06"=>3} みたな感じでハッシュで値が返る
        # -concernsとpostsをjoinしたテーブルを作って,その中からpostテーブルのenduser_idがログインユーザと同じものを検索で取得
        # -そして、取得したものをconcernsレコードの作成日ごとにグループ分けし、そのグループごとの数を数える(何日に何個気になる！をもらったか数える)

        # 一週間ごとのお気に入り数のグラフを作成
        c1 = Concern.joins(:post).where("posts.enduser_id in (?)", current_enduser.id).group("DATE(concerns.created_at)").count
        @concerns_week = []
        6.downto(1) do |i|
          temp = [i.days.ago.strftime('%b/%d'), c1.fetch("#{i.days.ago.strftime('%F')}", 0)]
          @concerns_week.push(temp)
        end
        @concerns_week.push([now.strftime('%b/%d'), c1.fetch("#{now.strftime('%F')}", 0)])
        @sumConcerns_week = @concerns_week.transpose[1].sum
        # 一週間ごとのお気に入り数のグラフを作成ここまで

        # 一週間ごとの自分の投稿に対してもらったコメント数のグラフを作成
        c2 = Comment.joins(:post).where("posts.enduser_id in (?)", current_enduser.id).group("DATE(comments.created_at)").count
        @comments_week = []
        6.downto(1) do |i|
          temp = [i.days.ago.strftime('%b/%d'), c2.fetch("#{i.days.ago.strftime('%F')}", 0)]
          @comments_week.push(temp)
        end
        @comments_week.push([now.strftime('%b/%d'), c2.fetch("#{now.strftime('%F')}", 0)])
        @sumComments_week = @comments_week.transpose[1].sum
        # 一週間ごとの自分の投稿に対してもらったコメント数のグラフを作成ここまで

        # 一ヶ月ごとの自分の投稿に対してもらった気になる数のグラフを作成
        # 一か月ごとの自分の投稿に対してもらった気になる数のグラフを作成ここまで

        # 年間で自分の投稿に対してもらったお気に入り数のグラフを作成
        c5 = Concern.joins(:post).where("posts.enduser_id in (?)", current_enduser.id).group_by_month("concerns.created_at", format: '%F').count
        @concerns_year = []
        11.downto(1) do |i|
          temp = [i.months.ago.beginning_of_month.strftime('%Y/%b'), c5.fetch("#{i.months.ago.beginning_of_month.strftime('%F')}", 0)]
          @concerns_year.push(temp)
        end
        @concerns_year.push([now.beginning_of_month.strftime('%Y/%b'), c5.fetch("#{now.beginning_of_month.strftime('%F')}", 0)])
        @sumConcerns_year = @concerns_year.transpose[1].sum
        # 年間で自分の投稿に対してもらったお気に入り数のグラフを作成ここまで

        # 年間で自分の投稿に対してもらったコメント数のグラフを作成
        c6 = Comment.joins(:post).where("posts.enduser_id in (?)", current_enduser.id).group_by_month("comments.created_at", format: '%F').count
        @comments_year = []
        11.downto(1) do |i|
          temp = [i.months.ago.beginning_of_month.strftime('%Y/%b'), c6.fetch("#{i.months.ago.beginning_of_month.strftime('%F')}", 0)]
          @comments_year.push(temp)
        end
        @comments_year.push([now.beginning_of_month.strftime('%Y/%b'), c6.fetch("#{now.beginning_of_month.strftime('%F')}", 0)])
        @sumConcerns_year = @comments_year.transpose[1].sum
        @sumComments_year = @comments_year.transpose[1].sum
        # 年間で自分の投稿に対してもらったお気に入り数のグラフを作成ここまで
  end

  def update
    @enduser = current_enduser
    @enduser.update!(enduser_params)
    redirect_to public_endusers_path(@enduser), notice: "登録情報の編集に成功しました"
  # 以下は例外処理の実行文。
  # アプリ試してもらったほとんどの人はエラー起きなかったが、たまに画像アップロードを使用した際たまにtextfilebusyのエラーがおきる
  # ９割方の人は問題なく使えており原因の特定が難しい(恐らく使用しているセキュリティーソフト等の関係 + windowsOSの関係？)ため、
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
