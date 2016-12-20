require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.new(email: 'user@example.com',
                     password: 'passpass')
  end

  describe 'User' do
    it 'should be valid' do
      expect(@user).to be_valid
    end
  end

  describe 'Email' do
    it 'should be present' do
      @user.email = '     '
      expect(@user).to be_invalid
    end

    it 'should not be to long' do
      @user.email = 'a' * 244 + '@example.com'
      expect(@user).to be_invalid
    end

    it 'validation should accept valid addresses' do
      valid_addresses = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn)
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid, "#{valid_address.inspect} should be valid"
      end
    end

    it 'validation should reject invalid addresses' do
      invalid_addresses = %w(foo@bar..com user@example,com user_at_foo.org
                             user.name@example. foo@bar_baz.com foo@bar+baz.com)
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).to be_invalid, "#{invalid_address.inspect} \
                                        should be invalid"
      end
    end
  end
end
