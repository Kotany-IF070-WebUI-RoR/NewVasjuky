require 'rails_helper'

describe Account::Admin::UsersController, type: :controller do
  let(:reporter) { create(:user, :reporter) }
  let(:banned_reporter) { create(:user, :reporter, banned: true) }
  let(:admin) { create(:user, :admin) }
  let!(:moderator) { create(:user, :moderator) }

  describe 'GET #index' do
    it 'when user is not logged in' do
      get :index
      expect(response).to redirect_to new_user_session_path
    end

    it 'when user is a reporter' do
      sign_in reporter
      get :index
      expect(response).to redirect_to root_path
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
    it 'when user is not logged in' do
      patch :change_role, params: { id: moderator.id,
                                    user: { role: 'reporter' } }
      moderator.reload
      expect(moderator.role).to eq('moderator')
    end

    it 'when user is a reporter' do
      sign_in reporter
      patch :change_role, params: { id: moderator.id,
                                    user: { role: 'reporter' } }
      moderator.reload
      expect(moderator.role).to eq('moderator')
    end

    it 'when user is a moderator' do
      sign_in moderator
      patch :change_role, params: { id: moderator.id,
                                    user: { role: 'reporter' } }
      moderator.reload
      expect(moderator.role).to eq('moderator')
    end

    it 'when user is a admin' do
      sign_in admin
      patch :change_role, params: { id: moderator.id,
                                    user: { role: 'reporter' } }
      moderator.reload
      expect(moderator.role).to eq('reporter')
    end
  end

  describe 'PATCH #toggle_ban' do
    context 'for banning reporter' do
      it 'when user is not logged in' do
        patch :toggle_ban, params: { id: reporter.id }
        reporter.reload
        expect(reporter.banned).to be false
      end

      it 'when logged user is a reporter' do
        sign_in reporter
        patch :toggle_ban, params: { id: reporter.id }
        reporter.reload
        expect(reporter.banned).to be false
      end

      it 'when logged user is a moderator' do
        sign_in moderator
        patch :toggle_ban, params: { id: reporter.id }
        reporter.reload
        expect(reporter.banned).to be true
      end

      it 'when logged user is a admin' do
        sign_in admin
        patch :toggle_ban, params: { id: reporter.id }
        reporter.reload
        expect(reporter.banned).to be true
      end

      it 'when unbanning' do
        sign_in admin
        patch :toggle_ban, params: { id: banned_reporter.id }
        banned_reporter.reload
        expect(banned_reporter.banned).to be false
      end
    end

    context 'for banning head users' do
      it 'when trying to ban moderator' do
        sign_in admin
        patch :toggle_ban, params: { id: moderator.id }
        moderator.reload
        expect(moderator.banned).to be false
      end

      it 'when trying to ban admin' do
        sign_in moderator
        patch :toggle_ban, params: { id: admin.id }
        admin.reload
        expect(admin.banned).to be false
      end
    end
  end
end
