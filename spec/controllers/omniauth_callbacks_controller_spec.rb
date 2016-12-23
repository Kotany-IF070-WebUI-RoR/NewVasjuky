require 'rails_helper'

describe Users::OmniauthCallbacksController, type: :controller do
  let(:succes_auth_text) { 'Successfully authenticated from Facebook account.' }
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
                   name: 'Vasya', email: 'vasya@pup.kin', password: 'password')
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

def env_for_omniauth
  request.env['devise.mapping'] = Devise.mappings[:user]
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] =
    OmniAuth::AuthHash.new(provider: 'facebook',
                           uid: '1234',
                           info: { name: 'Vasya',
                                   email: 'vasya@pup.kin' })
  request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
end
