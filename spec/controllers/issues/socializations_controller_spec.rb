require 'rails_helper'

describe Issues::SocializationsController, type: :controller do
  let(:reporter) { create(:user, :reporter) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :admin) }
  let(:issue) { create(:issue, user: reporter, status: 'opened') }

  describe 'Follow issue when' do
    let(:action) { post :follow, params: { issue_id: issue } }
    it 'user is not logged in' do
      action
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'user is reporter' do
      sign_in reporter
      action
      expect(response).to redirect_to(issue_path(issue))
      expect(reporter.follows?(issue)).to be_truthy
    end

    it 'user is admin' do
      sign_in admin
      action
      expect(response).to redirect_to(issue_path(issue))
      expect(admin.follows?(issue)).to be_truthy
    end

    it 'user is moderator' do
      sign_in moderator
      action
      expect(response).to redirect_to(issue_path(issue))
      expect(moderator.follows?(issue)).to be_truthy
    end
  end

  describe 'Unfollow issue when' do
    let(:follow) { post :follow, params: { issue_id: issue } }
    let(:unfollow) { post :unfollow, params: { issue_id: issue } }

    it 'user is not logged in' do
      unfollow
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'user is reporter' do
      sign_in reporter
      follow
      expect(reporter.follows?(issue)).to be_truthy
      unfollow
      expect(moderator.follows?(issue)).to be_falsey
    end

    it 'user is admin' do
      sign_in admin
      follow
      expect(admin.follows?(issue)).to be_truthy
      unfollow
      expect(moderator.follows?(issue)).to be_falsey
    end

    it 'user is moderator' do
      sign_in moderator
      follow
      expect(moderator.follows?(issue)).to be_truthy
      unfollow
      expect(moderator.follows?(issue)).to be_falsey
    end
  end
end
