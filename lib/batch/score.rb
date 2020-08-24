module Batch
  class Score
    def self.score
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
      p "Batch is done!"
    end
  end
end
