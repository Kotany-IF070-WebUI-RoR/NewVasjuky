require 'rails_helper'

describe Account::Admin::IssuesController do
  let(:reporter) { create(:user, :reporter) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :moderator) }
  let(:issue) { create(:issue) }

  describe 'Get #index' do
    let(:action) { get :index }
    it 'when user is not logged in' do
      expect(action).to have_http_status(302)
    end

    it 'when user is admin' do
      sign_in admin
      expect(action).to have_http_status(200)
      expect(action).to render_template(:index)
    end

    it 'when user is moderator' do
      sign_in moderator
      expect(action).to have_http_status(200)
      expect(action).to render_template(:index)
    end

    it 'when user is a reporter' do
      sign_in admin
      expect(action).to have_http_status(200)
      expect(action).to render_template(:index)
    end
  end

  describe 'Approve issues' do
    let(:action) { patch :approve, params: { id: issue.id } }
    before :each do
      @request.env['HTTP_REFERER'] = account_admin_issues_url
    end
    it 'when user is not logged in' do
      action
      expect(action).to have_http_status(302)
      issue.reload
      expect(issue.opened?).to be_falsey
    end

    it 'when user is admin' do
      sign_in admin
      action
      issue.reload
      expect(issue.opened?).to be_truthy
    end

    it 'when user is moderator' do
      sign_in moderator
      action
      issue.reload
      expect(issue.opened?).to be_truthy
    end

    it 'when user is a reporter' do
      sign_in reporter
      action
      issue.reload
      expect(issue.opened?).to be_falsey
    end
  end

  describe 'Decline issues' do
    let(:action) { patch :decline, params: { id: issue.id } }
    before :each do
      @request.env['HTTP_REFERER'] = account_admin_issues_url
    end
    it 'when user is not logged in' do
      action
      expect(action).to have_http_status(302)
      issue.reload
      expect(issue.declined?).to be_falsey
    end

    it 'when user is admin' do
      sign_in admin
      action
      issue.reload
      expect(issue.declined?).to be_truthy
    end

    it 'when user is moderator' do
      sign_in moderator
      action
      issue.reload
      expect(issue.declined?).to be_truthy
    end

    it 'when user is a reporter' do
      sign_in reporter
      action
      issue.reload
      expect(issue.declined?).to be_falsey
    end
  end

  describe 'Create event for.' do
    describe 'pending > approved' do
      let(:issue) { create(:issue) }
      it do
        sign_in admin
        expect(issue.events.count).to eq(0)
        patch :approve, params: { id: issue.id }
        issue.reload
        expect(issue.events.count).to eq(1)
        expect(Event.last.before_status).to eq('pending')
        expect(Event.last.after_status).to eq('opened')
      end
    end

    describe 'pending > declined' do
      let(:issue) { create(:issue) }
      it do
        sign_in admin
        expect(issue.events.count).to eq(0)
        patch :decline, params: { id: issue.id }
        issue.reload
        expect(issue.events.count).to eq(1)
        expect(Event.last.before_status).to eq('pending')
        expect(Event.last.after_status).to eq('declined')
      end
    end

    describe 'opened > closed' do
      let(:issue) { create(:issue, status: :opened) }
      it do
        sign_in admin
        expect(issue.events.count).to eq(0)
        issue.close!
        expect(issue.events.count).to eq(1)
        expect(Event.last.before_status).to eq('opened')
        expect(Event.last.after_status).to eq('closed')
      end
    end
  end
end
