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
    it { user.should_not be_nil }
    it do
      flash[:notice].should == succes_auth_text
    end
  end

  describe 'when facebook email doesn\'t exist in the system' do
    before(:each) do
      env_for_omniauth
      User.create!(provider: 'facebook', uid: '1234',
                   name: 'Vasya', email: 'vasya@pup.kin')
    end
    it { user.should_not be_nil }
    it do
      get :facebook
      flash[:notice].should eq(succes_auth_text)
      before_auth_user_count.should == User.count
    end
    it do
      get :facebook
      before_auth_user_count.should equal User.count
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
