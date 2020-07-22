class User < ApplicationRecord
  has_many :meetings, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[twitter google_oauth2]
        
    has_one_attached :image
    #has_one_attached :video

    before_create :generate_token

    validates :name, length: { maximum: 50 }
    validates :university, length: { maximum: 50 }
    validates :comment, length: { maximum: 250 }
    validates :twitter, length: { maximum: 100 }
    validates :instagram, length: { maximum: 150 }
    validates :other_link, length: { maximum: 150 }
    validate :image_content_type, if: :was_attached?

    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.username = auth.info.nickname
        user.email = auth.info.email if user.provider == "google_oauth2"
        user.email = User.dumy_email(auth) if user.provider == "twitter"
        twitter_image = auth.info.image.gsub("_normal","")
        user.image.attach(twitter_image) unless user.image.present?
        #user.image = auth.info.image if user.provider == "google_oauth2"
        user.password = Devise.friendly_token[0, 20] # ランダムなパスワードを作成
      end
    end

    def image_content_type
      extension = ['image/PNG', 'image/png', 'image/jpg', 'image/jpeg', 'image/JPEG', 'image/JPG']
      errors.add(:image, "の拡張子は「png PNG jpg jpeg JPG JPEG」のみ有効です") unless image.content_type.in?(extension)
    end

    def was_attached?
      self.image.attached?
    end

  def generate_token
    self.id = loop do
      random_token = SecureRandom.uuid
      break random_token unless self.class.exists?(id: random_token)
    end
  end

    private
    def self.dumy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end
end
