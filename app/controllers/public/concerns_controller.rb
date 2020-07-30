class Public::ConcernsController < ApplicationController
  def create
    @concern = Concern.new
    @concern.enduser_id = current_enduser.id
    @concern.post_id = params[:post_id]
    @concern.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @concern = Concern.find_by(post_id:params[:post_id], enduser_id: current_enduser.id)
    @concern.destroy
    redirect_back(fallback_location: root_path)
  end
end
