class User < ApplicationRecord
    include Devise::JWT::RevocationStrategies::Allowlist

    has_many :ner_models
    has_many :tasks
    has_many :allowlisted_jwts

    devise :database_authenticatable,
           :jwt_authenticatable, jwt_revocation_strategy: self

    def on_jwt_dispatch(token, payload)
        super
        AllowlistedJwt.where(user: self)  # Destroys still valid token when a new token is dispatched
                      .where('exp > ?', DateTime.now)
                      .where.not(jti: payload["jti"])
                      .destroy_all
    end

end
