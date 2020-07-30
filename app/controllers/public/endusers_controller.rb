class Public::EndusersController < ApplicationController
  def show
  end

  def edit
  end

  def update
    @enduser = current_enduser
    @enduser.update!(enduser_params)
    redirect_to public_endusers_path(@enduser), notice: "登録情報の編集に成功しました"
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
