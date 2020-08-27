class Admins::BatchesController < ApplicationController
  # natural_language_api戻り値の細かい説明　→　https://cloud.google.com/natural-language/docs/basics?hl=ja
  def index
  end

  def score
    # ユーザーごとのスコア付け
    endusers = Enduser.all
    from = Time.current.at_beginning_of_day
    to = (from + 6.day)
    weekDate = from .. to
    endusers.each do |enduser|
      if enduser.posts
        #各ユーザーに紐づいてる投稿を一つの文章にまとめる
        text = enduser.posts.where(created_at: weekDate).pluck(:body).join
        # natural_language_apiに文章を送って、scoreに評価された点数を格納　(apiとの通信の詳細は lib/language.rb で記述)
        # -1 ~ 1 の間で値がつけられ、-1に近づくほどネガティブ、1に近づくほどポジティブな投稿が多い
        score = Language.analyzeSentiment(text)['documentSentiment']['score']
        # 評価された値でユーザースコアの更新
        enduser.update_attribute(:score, score)
      end
    end
    redirect_to admins_batches_path
  end

  def entities
    # lib/twitter_client.rb内にnewのメソッドを定義していないが、newが動く理由としては、ruby側の仕様でnewというメソッド名を打つと自動でクラスやモジュール内のinitialize()というメソッドを探す仕組みになっているため
    # なので.newとあるが実際はinitialize()メソッドの呼び出しとなってる
    twitter = TwitterClient.new
    # twitter api を介して自分のサイトのハッシュタグ(今回は#MusicCircleTest01を作った)を検索し、ツイート本文部分を結合
    searchTweet= twitter.search("MusicCircleTest01", 50)
    text = searchTweet.pluck(:text).join("。").delete("MusicCircleTest01")
    # ツイートの文章の好感度をnatural language に送って評価してもらう
    scr = Language.analyzeSentiment(text)
    # ツイート文を natural language に送って単語ごとに切り分けてもらう
    ent = Language.analyzeEntities(text)
    entities = ent['entities'].pluck("name","salience").slice(0..4)

    # tw_sentimentテーブル用の変数
    # 最新のカラムが追加される前にこれまで最新になっていたカラムの状態を変更しとく
    if TwSentiment.where(latest: true)
      TwSentiment.where(latest: true).update_all(latest: false)
    end
    score = scr['documentSentiment']['score']
    twCount = searchTweet.count
    TwSentiment.create(score: score, tw_count: twCount)

    # tw_related_wordテーブル用の変数
    if TwRelatedWord.where(latest: true)
      TwRelatedWord.where(latest: true).update_all(latest: false)
    end
    entities.each do |entity|
      name = entity[0]
      salience = entity[1]
      TwRelatedWord.create(name: name, salience: salience)
    end
    redirect_to admins_batches_path
  end

end
