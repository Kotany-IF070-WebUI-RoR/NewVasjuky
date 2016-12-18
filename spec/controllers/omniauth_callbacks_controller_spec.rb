require 'rails_helper'

describe Users::OmniauthCallbacksController, type: :controller do
  before(:all) do
    @successfull_auth_text = 'Successfully authenticated from Facebook account.'
  end
  describe 'when facebook email doesn\'t exist in the system' do
    before(:each) do
      env_for_omniauth
      get :facebook
      @user = User.find_by(email: 'vasya@pup.kin')
    end
    it { @user.should_not be_nil }
    it do
      flash[:notice].should == @successfull_auth_text
    end
  end

  describe 'when facebook email doesn\'t exist in the system' do
    before(:each) do
      env_for_omniauth
      User.create!(provider: 'facebook', uid: '1234',
                   name: 'Vasya', email: 'vasya@pup.kin')
      @user = User.find_by(email: 'vasya@pup.kin')
      @before_auth_user_count = User.count
    end
    it { @user.should_not be_nil }
    it do
      get :facebook
      flash[:notice].should eq(@successfull_auth_text)
      @before_auth_user_count.should == User.count
    end
    it do
      get :facebook
      @before_auth_user_count.should equal User.count
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
