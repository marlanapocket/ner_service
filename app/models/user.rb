class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable
    devise :omniauthable, omniauth_providers: [:developer]

    def self.from_omniauth(auth)
        user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        # user.name = auth.info.name # assuming the user model has a name
        # user.image = auth.info.image # assuming the user model has an image
        user.save
        user
    end

end
