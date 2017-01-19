require 'rails_helper'

describe IssuesController, type: :controller do
  let(:reporter) { create(:user, :reporter) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :moderator) }
  let(:example_issue) { build(:issue) }
  describe 'GET #new' do
    it 'when user is not logged in' do
      get :new
      expect(response).to have_http_status(:found)
    end

    it 'when user is admin' do
      sign_in admin
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'when user is moderator' do
      sign_in moderator
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'when user is a reporter' do
      sign_in reporter
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'when user is not logged in' do
      expected = expect do
        post :create, params: {  issue: FactoryGirl.attributes_for(:issue)  }
      end
      expected.to change(Issue, :count).by(0)
    end

    it 'when user is a reporter' do
      pending('minor fix in test needed')
      sign_in reporter
      expected = expect do
        post :create, params: {  issue: FactoryGirl.attributes_for(:issue)  }
      end
      expected.to change(Issue, :count).by(1)
    end

    it 'when user is a moderator' do
      pending('minor fix in test needed')
      sign_in moderator
      expected = expect do
        post :create, params: {  issue: FactoryGirl.attributes_for(:issue)  }
      end
      expected.to change(Issue, :count).by(1)
    end

    it 'when user is a admin' do
      pending('minor fix in test needed')
      sign_in admin
      expected = expect do
        post :create, params: {  issue: FactoryGirl.attributes_for(:issue)  }
      end
      expected.to change(Issue, :count).by(1)
    end
  end

  describe 'Read issue when status is "pending"' do
    let!(:pending_issue) { create(:issue, status: 'pending') }
    let(:request) { get :show, params: { id: pending_issue.id } }
    let(:author) { pending_issue.user }

    it 'when user is not logged in' do
      expect(request).to have_http_status(302)
    end

    it 'when user is a reporter but not author of issue' do
      sign_in(reporter)
      expect(request).to have_http_status(302)
    end

    it 'when user is a reporter and author of issue' do
      sign_in(author)
      expect(request).to have_http_status(200)
    end

    it 'when user is a moderator' do
      sign_in(moderator)
      expect(request).to have_http_status(200)
    end

    it 'when user is a admin' do
      sign_in(admin)
      expect(request).to have_http_status(200)
    end
  end

  describe 'Read issue when status is "declined"' do
    let!(:declined_issue) { create(:issue, status: 'declined') }
    let(:request) { get :show, params: { id: declined_issue.id } }
    let(:author) { declined_issue.user }

    it 'when user is not logged in' do
      expect(request).to have_http_status(302)
    end

    it 'when user is a reporter but not author of issue' do
      sign_in(reporter)
      expect(request).to have_http_status(302)
    end

    it 'when user is a reporter and author of issue' do
      sign_in(author)
      expect(request).to have_http_status(200)
    end

    it 'when user is a moderator' do
      sign_in(moderator)
      expect(request).to have_http_status(200)
    end

    it 'when user is a admin' do
      sign_in(admin)
      expect(request).to have_http_status(200)
    end
  end
end
