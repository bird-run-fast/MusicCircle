class Admins::EndusersController < ApplicationController
  def destroy
    # destroyアクションだが実際はデータを残したままログインをできなくするための処理
    @enduser = Enduser.find(params[:id])
    @enduser.update(is_deleted: true)
    redirect_to root_path
  end
end
