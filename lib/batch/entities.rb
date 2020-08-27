module Batch
  class Entities
    def self.entities
      # TwitterClientとLanguageクラスはlibファイル直下で自作。細かいメソッド内容はそこを参照。
      # ただlib/twitter_client.rb内にnewのメソッドを定義していないがnewが動く。理由としてはruby側の仕様でnewというメソッド名を打つと自動でクラスやモジュール内のinitialize()というメソッドを探す仕組みになっているため
      # なので.newとあるが実際はinitialize()メソッドの呼び出しとなってる
      twitter = TwitterClient.new
      # twitter api を介してサイトのハッシュタグ(#MusicCircleTest01と仮定)を検索し、ツイート本文部分を結合
      searchTweet= twitter.search("MusicCircleTest01", 50)
      text = searchTweet.pluck(:text).join("。").delete("MusicCircleTest01")
      # ツイートの文章の好感度をnatural language に送って評価してもらう
      scr = Language.analyzeSentiment(text)
      # ツイート文を natural language に送って単語ごとに切り分けてもらい。上位５つを変数に格納
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
      
      p "Batch is done!"
    end
  end
end
