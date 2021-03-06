class Enduser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  #deviseの初期設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # refileの初期設定
  attachment :image

  # テーブル間のアソシエーション
  has_many :posts
  has_many :concerns
  has_many :concern_posts, through: :concerns, source: :post
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :rooms, through: :entries# Endusersテーブルから(中間てーぶるを介した)roomsテーブルへの関連付け
  accepts_nested_attributes_for :entries
  has_many :comments
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # バリデーション部分
  validates :name, presence: true
  validates :area, presence: true
  validates :age, presence: true

  # enum型の設定
  enum area: {
    北海道:1,青森県:2,岩手県:3,宮城県:4,秋田県:5,山形県:6,福島県:7,
    茨城県:8,栃木県:9,群馬県:10,埼玉県:11,千葉県:12,東京都:13,神奈川県:14,
    新潟県:15,富山県:16,石川県:17,福井県:18,山梨県:19,長野県:20,
    岐阜県:21,静岡県:22,愛知県:23,三重県:24,
    滋賀県:25,京都府:26,大阪府:27,兵庫県:28,奈良県:29,和歌山県:30,
    鳥取県:31,島根県:32,岡山県:33,広島県:34,山口県:35,
    徳島県:36,香川県:37,愛媛県:38,高知県:39,
    福岡県:40,佐賀県:41,長崎県:42,熊本県:43,大分県:44,宮崎県:45,鹿児島県:46,沖縄県:47
  }

  enum age: {
    １０代前半:1,１０代後半:2,２０代前半:3,２０代後半:4,３０代前半:5,３０代後半:6,
    ４０代前半:7,４０代後半:8,５０代前半:9,５０代後半:10,６０代前半:11,６０代後半:7,７０代以降:8
  }

  # この記述でdeviseのもとからあったactive_for_authentication?メソッドを上書きしている
  # superはクラスの継承が行われていて、同名のメソッドがある場合に、親クラスの同名メソッドの記述をもってくる記述
  # 今回は親クラスのもとからあった記述に加え、enduserモデルのis_deletedがfalseであることを条件に加えて上書き
  def active_for_authentication?
    super && (self.is_deleted == false)
  end
end
