# Encoding: utf-8
require 'rails_helper'

describe Users::OmniauthCallbacksController, type: :controller do
  let(:succes_auth_text) { 'Вхід з облікового запису Facebook успішний.' }
  let(:user) { User.find_by(email: 'vasya@pup.kin') }
  let(:before_auth_user_count) { User.count }

  describe 'when facebook email doesn\'t exist in the system' do
    before(:each) do
      env_for_omniauth
      get :facebook
    end
    it { expect(user).not_to be_nil }

    it { expect(flash[:notice]).to eq succes_auth_text }
  end

  describe 'when facebook email doesn\'t exist in the system' do
    before(:each) do
      env_for_omniauth
      User.create!(provider: 'facebook', uid: '1234',
                   first_name: 'Vasya', last_name: 'Pupkin',
                   email: 'vasya@pup.kin')
    end
    it { expect(user).not_to be_nil }
    it do
      get :facebook
      expect(flash[:notice]).to eq succes_auth_text
      expect(before_auth_user_count).to eq User.count
    end
    it do
      get :facebook
      expect(before_auth_user_count).to eq User.count
    end
  end

  describe 'when facebook user does not have email' do
    before(:each) do
      env_for_omniauth(false)
      User.create!(provider: 'facebook', uid: '1234',
                   first_name: 'Vasya', last_name: 'Pupkin',
                   email: 'vasya@pup.kin')
    end
    it { expect(user).not_to be_nil }
    it do
      get :facebook
      expect(flash[:notice]).to eq succes_auth_text
      expect(before_auth_user_count).to eq User.count
    end
    it do
      get :facebook
      expect(before_auth_user_count).to eq User.count
    end
  end
end

def env_for_omniauth(email = true)
  request.env['devise.mapping'] = Devise.mappings[:user]
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = omni_auth_env_data_for_facebook(email)

  request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
end

def omni_auth_env_data_for_facebook(email)
  @image_path = File.open("#{Rails.root}/spec/files/avatar.jpg")
  @fb_hash = OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234',
                                    info: { first_name: 'Vasya',
                                            last_name: 'Pupkin',
                                            image: @image_path })
  @fb_hash.info.email = 'vasya@pup.kin' if email
  @fb_hash
end
