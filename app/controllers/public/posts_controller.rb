class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def index
    @posts = Post.all.order(created_at: "DESC")
    @hotTags = Tag.joins(:post_tags).group(:tag_id).order("count(post_id) desc").limit(10)
  end

  def show
    @post = Post.find(params[:id])
    @hotTags = Tag.joins(:post_tags).group(:tag_id).order("count(post_id) desc").limit(10)
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
