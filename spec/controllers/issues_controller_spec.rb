require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
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
      sign_in reporter
      expected = expect do
        post :create, params: {  issue: FactoryGirl.attributes_for(:issue)  }
      end
      expected.to change(Issue, :count).by(1)
    end

    it 'when user is a moderator' do
      sign_in moderator
      expected = expect do
        post :create, params: {  issue: FactoryGirl.attributes_for(:issue)  }
      end
      expected.to change(Issue, :count).by(1)
    end

    it 'when user is a admin' do
      sign_in admin
      expected = expect do
        post :create, params: {  issue: FactoryGirl.attributes_for(:issue)  }
      end
      expected.to change(Issue, :count).by(1)
    end
  end
end
