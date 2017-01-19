require 'rails_helper'

describe UsersController, type: :controller do
  let(:reporter) { create(:user, :reporter) }
  let(:issue) { create(:issue, user: reporter) }
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
end
