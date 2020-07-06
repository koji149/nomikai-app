class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[twitter google_oauth2]
        
    has_one_attached :image
    has_one_attached :video

    validates :name, presence: true


    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.name
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20] # ランダムなパスワードを作成
      end
    end
end
