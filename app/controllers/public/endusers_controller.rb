class Public::EndusersController < ApplicationController
  def show
  end

  def edit
  end

  def update
    @enduser = current_enduser
    if @enduser.update(enduser_params)
      redirect_to public_endusers_path(@customer), notice: "登録情報の編集に成功しました"
    else
      render :edit
    end
  end

  private
  def enduser_params
    params.require(:enduser).permit(:name, :email, :introduction, :area, :age, :image)
  end
end
