class Public::SearchesController < ApplicationController
  def index
    @allTags = Tag.all.limit(40)
    @posts = []
    # ユーザー名検索であればparams[:searchUser]に値が入った状態でパラメーターが送られてくる
    if params[:searchUser]
      @word = params[:searchUser]
      @endusers = search_enduser(@word)
      @endusers.each do |enduser|
        tempPosts = enduser.posts
        @posts += tempPosts.includes([:post_tags, :tags, :enduser])
      end
    # タグ名検索であればparams[:searchTag]に値が入った状態でパラメーターが送られてくる
    elsif params[:searchTag]
      @word = params[:searchTag]
      # @tagsは検索ワードに部分一致したタグのIDを配列で取得している。
      @tags = search_tag(@word)
      # 学習メモ: postsテーブルとpostTagsテーブルをjoin(内部結合)した後、結合後のテーブルに対して、検索条件と一致するタグ(@tags)と紐づくPostを取得している。
      # joinを使った場合のwhereについて、結合した親テーブル(Posts)のカラムで検索する場合は普通のwhere文で検索できる。子テーブル(post_tags)のカラムで検索する場合は カラム名の前にテーブル名をつけて、""で囲ってあげる必要がある。
      # where内の(?)はワイルドカードと呼ばれ、第二引数以降に指定た値を代入する記述。今回はで言えばpost_tags.tag_id in (@tags)が実行されてる。@tagsが複数でも対応可能でめちゃ便利な記述方法。
      @posts = Post.joins(:post_tags).where("post_tags.tag_id in (?)",@tags).includes([:tags,:enduser])
    end
  end

  private
  def search_tag(word)
    Tag.where('name LIKE ?', "%#{word}%").pluck(:id)
  end

  def search_enduser(word)
    Enduser.where('name LIKE ?', "%#{word}%").includes(:posts)
  end
end
