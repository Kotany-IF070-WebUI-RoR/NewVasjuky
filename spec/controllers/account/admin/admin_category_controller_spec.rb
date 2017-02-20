require 'rails_helper'

describe Account::Admin::CategoriesController do
  let(:reporter) { create(:user, :reporter) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :moderator) }
  let(:issue) { create(:issue) }

  describe 'Get #index' do
    let(:action) { get :index }
    it 'when user is not logged in' do
      expect(action).to have_http_status(302)
    end

    it 'when user is a reporter' do
      sign_in admin
      expect(action).to have_http_status(200)
      expect(action).to render_template(:index)
    end

    it 'when user is moderator' do
      sign_in moderator
      expect(action).to have_http_status(200)
      expect(action).to render_template(:index)
    end

    it 'when user is admin' do
      sign_in admin
      expect(action).to have_http_status(200)
      expect(action).to render_template(:index)
    end
  end
end
