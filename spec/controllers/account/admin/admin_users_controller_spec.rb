require 'rails_helper'

describe Account::Admin::UsersController, type: :controller do
  let(:reporter) { create(:user, :reporter) }
  let(:admin) { create(:user, :admin) }
  let!(:moderator) { create(:user, :moderator) }

  describe 'GET #index' do
    before :each do
      @request.env['HTTP_REFERER'] = account_admin_issues_url
    end
    
    it 'when user is not logged in' do
      get :index
      expect(response).not_to redirect_to account_admin_users_path
    end

    it 'when user is a reporter' do
      sign_in reporter
      get :index
      expect(response).not_to redirect_to account_admin_users_path
    end

    it 'when user is a moderator' do
      sign_in moderator
      get :index
      expect(response).to render_template(:index)
    end

    it 'when user is a admin' do
      sign_in admin
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'PATCH #change_role' do
    before :each do
      @request.env['HTTP_REFERER'] = account_admin_issues_url
    end
    
    it 'when user is not logged in' do
      patch :change_role, params: { id: moderator.id, user: { role: 'reporter' } }
      moderator.reload
      expect(moderator.role).to eq('moderator')
    end

    it 'when user is a reporter' do
      sign_in reporter
      patch :change_role, params: { id: moderator.id, user: { role: 'reporter' } }
      moderator.reload
      expect(moderator.role).to eq('moderator')
    end

    it 'when user is a moderator' do
      sign_in moderator
      patch :change_role, params: { id: moderator.id, user: { role: 'reporter' } }
      moderator.reload
      expect(moderator.role).to eq('moderator')
    end

    it 'when user is a admin' do
      sign_in admin
      patch :change_role, params: { id: moderator.id, user: { role: 'reporter' } }
      moderator.reload
      expect(moderator.role).to eq('reporter')
    end
  end
end
