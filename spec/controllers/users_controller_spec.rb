require 'rails_helper'

describe UsersController, type: :controller do
  let!(:reporter) { create(:user, :reporter) }
  let!(:another_reporter) { create(:user, :reporter) }
  let!(:issue) do
    create(:issue, user: reporter,
                   created_at: 9.days.ago, status: :opened)
  end
  let!(:another_issue) do
    create(:issue, user: another_reporter,
                   created_at: 35.days.ago, status: :opened)
  end

  describe 'GET #show' do
    it 'when user is not logged in' do
      get :show, params: { id: reporter.id }
      expect(response).to have_http_status(302)
    end

    it 'when user is logged in' do
      sign_in reporter
      get :show, params: { id: reporter.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'Ranking' do
    it '7 days period' do
      get :ranking, params: { period: 7 }
      expect(assigns(:users).length).to eq(0)
    end

    it '30 day period' do
      get :ranking, params: { period: 30 }
      expect(assigns(:users).length).to eq(1)
    end

    it '90 days period' do
      get :ranking, params: { period: 90 }
      expect(assigns(:users).length).to eq(2)
    end

    it 'not valid period' do
      get :ranking, params: { period: 555 }
      expect(assigns(:users).length).to eq(1)
    end
  end
end
