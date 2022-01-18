class OmniauthCallbacksController < Devise::OmniauthCallbacksController

    def developer
        @user = User.from_omniauth request.env['omniauth.auth']
    end

end