class ApplicationController < ActionController::Base
  # protected以下に記述がある関数を呼び出している。ユーザー新規登録用の記述
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  # ユーザーの新規登録時、どのカラムの情報をフォームから受け取るのかを設定している。
  # deviseの初期設定だと、devise生成時に自動で作成されるカラム(email,パスワード等)の情報しか受け取れない設定になるため、
  # 自分で追加したカラムの情報をフォームから受け取りたいときはこの記述が必要
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :introduction, :area, :age])
  end
end
