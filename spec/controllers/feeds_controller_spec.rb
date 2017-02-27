require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  let(:reporter) do
    create(:user, :reporter, last_check_notifications_at: Time.zone.now)
  end
  let(:admin) { create(:user, :admin) }
  let(:banned_reporter) { create(:user, :reporter, active: false) }

  describe 'Open common feed when' do
    let(:action) { get :common_feed }
    it 'user is not signed in' do
      expect(action).to have_http_status(200)
    end

    it 'user is signed in' do
      sign_in reporter
      expect(action).to have_http_status(200)
    end
  end

  describe 'Open users feed when' do
    let(:action) { get :user_feed }
    it 'user is not signed in' do
      expect(action).to have_http_status(302)
    end

    it 'user is signed in' do
      sign_in reporter
      expect(action).to have_http_status(200)
    end
  end

  describe 'Open users feed when user is baned and' do
    let(:action) { get :common_feed }
    it 'signed in' do
      sign_in banned_reporter
      expect(action).to have_http_status(200)
    end
  end

  describe 'User should' do
    let(:issue) { create(:issue) }
    let(:event) do
      build(:event, author_id: admin.id, before_status: :pending,
                    after_status: :opened, issue: issue)
    end

    it 'get notification when follower and not author of event' do
      reporter.follow!(issue)
      expect(reporter.new_notifications.any?).to be_falsey
      issue.approve!
      issue.create_event(event)
      expect(reporter.new_notifications.any?).to be_truthy
    end

    it 'read notification when open user_feed page' do
      reporter.follow!(issue)
      expect(reporter.new_notifications.any?).to be_falsey
      issue.approve!
      issue.create_event(event)
      reporter.reload
      expect(reporter.new_notifications.any?).to be_truthy
      sign_in reporter
      get :user_feed
      reporter.reload
      expect(reporter.new_notifications.any?).to be_falsey
    end

    it 'mark as read notifications when load it' do
      reporter.follow!(issue)
      issue.approve!
      issue.create_event(event)
      expect(reporter.notifications.last.readed).to be_falsey
      sign_in reporter
      get :user_feed, xhr: true
      expect(reporter.notifications.last.readed).to be_truthy
    end

    describe 'not get notification when' do
      it 'follower and author of event' do
        admin.follow!(issue)
        expect(admin.new_notifications.any?).to be_falsey
        issue.approve!
        issue.create_event(event)
        expect(admin.new_notifications.any?).to be_falsey
      end

      it 'get notification when not follower and not author of event' do
        expect(reporter.new_notifications.any?).to be_falsey
        issue.approve!
        issue.create_event(event)
        expect(reporter.new_notifications.any?).to be_falsey
      end
    end
  end
end
