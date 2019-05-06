class User < ApplicationRecord
  devise :database_authenticatable, 
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates :email, presence: true, uniqueness: true

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
  end
end
