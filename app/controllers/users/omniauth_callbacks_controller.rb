# frozen_string_literal: true
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        sign_in_via_facebook
      else
        session['devise.facebook_data'] = request.env['omniauth.auth']
      end
    end

    def failure
      redirect_to root_path
    end

    private

    def sign_in_via_facebook
      sign_in_and_redirect @user, event: :authentication
      return unless is_navigational_format?
      set_flash_message(:notice, :success, kind: 'Facebook')
    end
  end
end
