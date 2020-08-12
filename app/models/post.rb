class Post < ApplicationRecord
  # テーブル間のアソシエーション
  belongs_to :enduser
  has_many :concerns
  has_many :concern_endusers, through: :concerns, source: :enduser
  has_many :post_tags, dependent: :destroy# postテーブルからpost_tag(中間テーブル)に対する関連付け
  has_many :tags, through: :post_tags# postテーブルから(中間てーぶるを介した)tagsテーブルへの関連付け
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # バリデーション部分
  validates :title, presence: true
  validates :body, presence: true

  # enum型の設定
  enum is_valid: {募集中:0, 募集終了:1}

  # 関数の設定
  # いいねされてるかを判断する関数
  def concerned_by?(enduser)
    concerns.where(enduser_id: enduser.id).exists?
  end

  # 「いいね」時に通知を作成する関数(通知機能)
  def create_notification_like!(current_enduser)
    # すでに「いいね」されている通知をしたことあるか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_enduser.id, enduser_id, id, 'concern'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_enduser.active_notifications.new(
        post_id: id,
        visited_id: enduser_id,
        action: 'concern'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
  # 「いいね」時に通知を作成する関数(通知機能)ここまで

  # コメント時に通知を作成する関数(通知機能)
  def create_notification_comment!(current_enduser, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:enduser_id).where(post_id: id).where.not(enduser_id: current_enduser.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_enduser, comment_id, temp_id['enduser_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_enduser, comment_id, enduser_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_enduser, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_enduser.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
  # コメント時に通知を作成する関数通知機能)
end
