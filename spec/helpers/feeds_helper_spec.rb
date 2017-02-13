require 'rails_helper'
RSpec.describe FeedsHelper, type: :helper do
  it 'Should return true when users feed' do
    controller.params[:controller] = 'feeds'
    controller.params[:action] = 'user_feed'
    expect(users_feed?).to be_truthy
  end

  it 'Should return true when not users feed' do
    controller.params[:controller] = 'feeds'
    controller.params[:action] = 'common_feed'
    expect(users_feed?).to be_falsey
  end

  it 'Should return true when common_feed' do
    controller.params[:controller] = 'feeds'
    controller.params[:action] = 'common_feed'
    expect(common_feed?).to be_truthy
  end

  it 'Should return true when not common_feed' do
    controller.params[:controller] = 'feeds'
    controller.params[:action] = 'user_feed'
    expect(common_feed?).to be_falsey
  end
end
