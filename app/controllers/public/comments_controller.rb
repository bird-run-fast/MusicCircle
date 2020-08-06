class Public::CommentsController < ApplicationController
  def create
    @comment = current_enduser.comments.new(comment_params)
    @comment.post_id = params[:post_id]
    @comment.enduser_id = current_enduser.id
    @post = @comment.post
    if @comment.save
      @post.create_notification_comment!(current_enduser, @comment.id)
      redirect_back(fallback_location: root_path)  #コメント送信後は、一つ前のページへリダイレクトさせる。
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :post_id)  #formにてpost_idパラメータを送信して、コメントへpost_idを格納するようにする必要がある。
  end
end
