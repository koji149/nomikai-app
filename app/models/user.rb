class User < ApplicationRecord
  has_many :meetings, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[twitter google_oauth2]
        
    has_one_attached :image
    has_one_attached :video

    validates :name, length: { maximum: 50 }
    validates :university, length: { maximum: 50 }
    validates :comment, length: { maximum: 250 }
    validates :twitter, length: { maximum: 100 }
    validates :instagram, length: { maximum: 100 }
    validates :other_link, length: { maximum: 100 }

    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.email = auth.info.email
        user.image.attach(auth.info.image.gsub("_normal","")) if user.provider == "twitter"
        user.image.attach(auth.info.image) if user.provider == "google_oauth2"
        user.password = Devise.friendly_token[0, 20] # ランダムなパスワードを作成
      end
    end
end
