class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def index
    @posts = Post.all.order(created_at: "DESC")
    @hotPosts = Post.joins(:concerns).group(:post_id).order("count(enduser_id) desc").limit(5)
    @hotTags = Tag.joins(:post_tags).group(:tag_id).order("count(post_id) desc").limit(10)
  end

  def show
    @post = Post.find(params[:id])

    # コメント用の変数
    @comments = @post.comments
    @comment = Comment.new
    # コメント用の変数ここまで

    # sidebar用の変数部分
    # -@hotPostsについて
    # -1PostsテーブルとConcernsテーブルをpost_idをキーとして(.joinで)くっつけて一つのテーブルを作り
    # -作ったテーブルをpost_idの種類ごとにグループ分けし
    # -その各グループの中で重複してるenduser_idが多い順にグループ分けしている
    # -要は同一のpost_idが何個のenduser_idと紐づきを持ってるかカウントして紐づき多い順に並び替えしてる
    @hotPosts = Post.joins(:concerns).group(:post_id).order("count(enduser_id) desc").limit(3)
    @hotTags = Tag.joins(:post_tags).group(:tag_id).order("count(post_id) desc").limit(10)
    # sidebar用の変数(人気の募集と人気のタグの表示用)部分ここまで


    # DM機能用の変数
    if enduser_signed_in?
      # view内のDMボタンが押されたときにDMのroomに移動もしくはcreateしたい
      # 誰(@currentEnduserEntry)と誰(@enduserEntry)のDMなのかをentriesテーブルに記録したいので、whereを使って値を取得
      @currentEnduserEntry = Entry.where(enduser_id: current_enduser.id)
      @enduserEntry = Entry.where(enduser_id: @post.enduser_id)
      # 現在ログインしているユーザーが,showアクションで表示しているユーザーと違ければ
      if @post.enduser_id == current_enduser.id
      else
        # @currentEnduserEntryと@enduserEntryの組合わせ全通りを試して(=それぞれの変数でeach doして)
        @currentEnduserEntry.each do |cu|
          @enduserEntry.each do |u|
            # すでにこの2ユーザーに対する部屋が作られていれば(= cu.room_id == u.room_idであれば)
            # -ちなみに2ユーザーの同じ組み合わせのentriesカラムは作られないように設計するため
            # -(DMしたことあれば)全組合わせを試すなかで,1回だけif文の中身が実行されるはずって前提
            if cu.room_id == u.room_id then
              # @isRoom(=room作成済みかどうかのフラグ)と@roomIdを作成
              @isRoom = true
              @roomId = cu.room_id
            end
          end
        end
        # もし今までDMしたことがなければ(上のif中いかず@isRoomは宣言されてないので)
        if @isRoom
        else
          # (フォーム用の)新規roomと新規entryを作成する
          @room = Room.new
          @entry = Entry.new
        end
      end
    end
      # DM機能用の変数ここまで

  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.enduser_id = current_enduser.id
    if @post.save
      params[:tags].each do |t|
        tag = Tag.find_or_create_by(name: t)
        @post_tag =  PostTag.new(post_id: @post.id,tag_id: tag.id)
        @post_tag.save
      end
      redirect_to public_posts_path, notice: "募集の投稿に成功しました！"
    else
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      @post.post_tags.destroy_all
      params[:tags].each do |t|
        tag = Tag.find_or_create_by(name: t)
        @post_tag =  PostTag.new(post_id: @post.id,tag_id: tag.id)
        @post_tag.save
      end
      redirect_to public_posts_path, notice: "募集内容の編集に成功しました"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to public_posts_path, notice: "募集の削除に成功しました！"
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :is_valid, :tag_ids)
  end

end
