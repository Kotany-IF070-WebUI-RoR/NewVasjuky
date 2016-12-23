require 'rails_helper'

describe Account::UsersController, type: :controller do
  let(:reporter) { create(:user, :reporter) }
  let(:admin) { create(:user, :admin) }
  let!(:moderator) { create(:user, :moderator) }

  describe 'GET #new' do
    it 'when user is not logged in' do
      get :new
      expect(response).not_to redirect_to new_account_user_path
    end

    it 'when user is admin' do
      sign_in admin
      get :new
      expect(response).to render_template(:new)
    end

    it 'when user is moderator' do
      sign_in moderator
      get :new
      expect(response).not_to redirect_to new_account_user_path
    end

    it 'when user is a reporter' do
      sign_in reporter
      get :new
      expect(response).not_to redirect_to new_account_user_path
    end
  end

  describe 'POST #create' do
    it 'when user is not logged in' do
      expected = expect do
        post :create, params: {  user: FactoryGirl.attributes_for(:user)  }
      end
      expected.to change(User, :count).by(0)
    end

    it 'when user is a reporter' do
      sign_in reporter
      expected = expect do
        post :create, params: {  user: FactoryGirl.attributes_for(:user)  }
      end
      expected.to change(User, :count).by(0)
    end

    it 'when user is a moderator' do
      sign_in moderator
      expected = expect do
        post :create, params: {  user: FactoryGirl.attributes_for(:user)  }
      end
      expected.to change(User, :count).by(0)
    end

    it 'when user is a admin' do
      sign_in admin
      expected = expect do
        post :create, params: {  user: FactoryGirl.attributes_for(:user)  }
      end
      expected.to change(User, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    it 'when user is not logged in' do
      expected = expect do
        delete :destroy, params: { id: moderator.id }
      end
      expected.to change(User, :count).by(0)
    end

    it 'when user is a reporter' do
      sign_in reporter
      expected = expect do
        delete :destroy, params: { id: moderator.id }
      end
      expected.to change(User, :count).by(0)
    end

    it 'when user is a moderator' do
      sign_in moderator
      expected = expect do
        delete :destroy, params: { id: moderator.id }
      end
      expected.to change(User, :count).by(0)
    end

    it 'when user is a admin' do
      sign_in admin
      expected = expect do
        delete :destroy, params: { id: moderator.id }
      end
      expected.to change(User, :count).by(-1)
    end
  end
end
