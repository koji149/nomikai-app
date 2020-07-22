class Meeting < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :area, presence: { message: 'を選択してください' }
  validates :date, presence: { message: 'を選択してください' }
  validates :time, presence: { message: 'を選択してください' }
  validates :bar, length: { in: 1..100 }
  validates :url, length: { in: 1..175 }
  validates :explain, length: { in: 1..400 }
  validate :image_content_type, if: :was_attached?
  
  geocoded_by :bar
  after_validation :geocode

  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude,
                   :default_units => :kms
  def image_content_type
    extension = ['image/PNG', 'image/png', 'image/jpg', 'image/jpeg', 'image/JPEG', 'image/JPG']
    errors.add(:image, "の拡張子は「png PNG jpg jpeg JPG JPEG」のみ有効です") unless image.content_type.in?(extension)
  end
  
  def was_attached?
    self.image.attached?
  end

  #enum area: {
    #北海道:1,青森県:2,岩手県:3,宮城県:4,秋田県:5,山形県:6,福島県:7,
    #茨城県:8,栃木県:9,群馬県:10,埼玉県:11,千葉県:12,東京都:13,神奈川県:14,
    #新潟県:15,富山県:16,石川県:17,福井県:18,山梨県:19,長野県:20,
    #岐阜県:21,静岡県:22,愛知県:23,三重県:24,
    #滋賀県:25,京都府:26,大阪府:27,兵庫県:28,奈良県:29,和歌山県:30,
    #鳥取県:31,島根県:32,岡山県:33,広島県:34,山口県:35,
    #徳島県:36,香川県:37,愛媛県:38,高知県:39,
    #福岡県:40,佐賀県:41,長崎県:42,熊本県:43,大分県:44,宮崎県:45,鹿児島県:46,沖縄県:47
  #}

  enum area: {
    埼玉県:11,東京都:13,大阪府:27,福岡県:40
  }
end
