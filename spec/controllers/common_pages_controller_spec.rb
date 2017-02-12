require 'rails_helper'

describe CommonPagesController, type: :controller do
  let(:reporter) { create(:user, :reporter) }
  let(:banned_reporter) { create(:user, :reporter, banned: true) }

  describe 'GET #home' do
    it 'when user is not logged in' do
      get :home
      expect(response).to have_http_status(200)
    end

    it 'when user is a reporter' do
      sign_in reporter
      get :home
      expect(response).to have_http_status(200)
    end

    it 'when user is a banned reporter' do
      sign_in banned_reporter
      get :home
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #statistics' do
    it 'with invalid params[:period]' do
      get :statistics, params: { period: 'invalid', sort: 'category' }
      expect(response).to have_http_status(302)
    end

    it 'with invalid params[:sort]' do
      get :statistics, params: { period: 'year', sort: 'invalid' }
      expect(response).to have_http_status(302)
    end

    it 'with valid params' do
      get :statistics, params: { period: 'total', sort: 'time' }
      expect(response).to have_http_status(200)
    end

    it 'when user is a banned reporter' do
      sign_in banned_reporter
      get :statistics, params: { period: 'month', sort: 'category' }
      expect(response).to have_http_status(200)
    end
  end
end
