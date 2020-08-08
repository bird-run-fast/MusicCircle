class Public::EndusersController < ApplicationController
  def show
  end

  def edit
  end

  def update
    @enduser = current_enduser
    @enduser.update!(enduser_params)
    redirect_to public_endusers_path(@enduser), notice: "登録情報の編集に成功しました"
  # 以下は例外処理の実行文。
  # アプリ試してもらったほとんどの人はエラー起きなかったが、たまに画像アップロードを使用した際たまにtextfilebusyのエラーがおきる
  # ９割方の人は問題なく使えており原因の特定が難しい(恐らく使用しているセキュリティーソフト等の関係 + windows使用の関係？)ため、
  # とりあえずエラーが起きたらnotice文を出してユーザーにエラーを伝え、もう一度画像アップロードをしてもらう(何回か試すと成功するため)。
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
