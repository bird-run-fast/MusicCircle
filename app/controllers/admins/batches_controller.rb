class Admins::BatchesController < ApplicationController
  # text = Post.where(enduser_id: 2).pluck(:body)[0]
  # @sentiment = Language.analyzeSentiment(text)['documentSentiment']['score']
  # @entities = Language.analyzeEntities(text)
  # api戻り値の細かい説明　→　https://cloud.google.com/natural-language/docs/basics?hl=ja
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
    # endusers = Enduser.all
    # from = Time.current.at_beginning_of_day
    # to = (from + 6.day)
    # weekDate = from .. to
    #
    # text = Post.where(created_at: weekDate).pluck(:body).join
    # entities = Language.analyzeEntities(text)['entities'].pluck("name")
    # countEntities = entities.group_by(&:itself).map{|k, v|[k, v.count]}
    # hotEntities = countEntities.sort{|a, b| a[1] <=> b[1]}.reverse.slice(0..4)

    

  end

end
