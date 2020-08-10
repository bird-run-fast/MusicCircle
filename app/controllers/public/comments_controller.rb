class Public::CommentsController < ApplicationController
  before_action :authenticate_enduser!
  def create
    @comment = current_enduser.comments.new(comment_params)
    @comment.post_id = params[:post_id]
    @comment.enduser_id = current_enduser.id
    if @comment.save
      @post = @comment.post
      @post.create_notification_comment!(current_enduser, @comment.id)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :post_id)  #formにてpost_idパラメータを送信して、コメントへpost_idを格納するようにする必要がある。
  end
end
