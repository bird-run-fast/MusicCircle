class Public::ConcernsController < ApplicationController
  before_action :authenticate_enduser!
  def create
    @concern = Concern.new
    @concern.enduser_id = current_enduser.id
    @concern.post_id = params[:post_id]
    @concern.save
    @post = Post.find(params[:post_id])
    @post.create_notification_like!(current_enduser)
  end

  def destroy
    @concern = Concern.find_by(post_id:params[:post_id], enduser_id: current_enduser.id)
    @concern.destroy
  end
end
