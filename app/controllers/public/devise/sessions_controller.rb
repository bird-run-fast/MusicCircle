# frozen_string_literal: true

class Public::Devise::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :reject_user, only: [:create]


  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  def reject_user
    @enduser = Enduser.find_by(email: params[:enduser][:email].downcase)
    if @enduser
      if (@enduser.valid_password?(params[:enduser][:password]) && (@enduser.active_for_authentication? == false))
        flash[:notice] = "退会済みです。"
        redirect_to new_enduser_session_path
      end
    else
      flash[:error] = "必須項目を入力してください。"
    end
  end

end
