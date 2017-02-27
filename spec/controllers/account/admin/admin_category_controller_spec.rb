require 'rails_helper'

describe Account::Admin::CategoriesController do
  let(:reporter) { create(:user, :reporter) }
  let(:moderator) { create(:user, :moderator) }
  let(:admin) { create(:user, :admin) }
  let(:category) { create(:category) }
  let(:category_params) { FactoryGirl.attributes_for(:category) }

  describe 'GET #index' do
    let(:action) { get :index }

    it 'when user is not logged in' do
      expect(action).to have_http_status(302)
    end

    it 'when user is a reporter' do
      sign_in reporter
      expect(action).to have_http_status(302)
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

  describe 'GET #show' do
    before :each do
      sign_in admin
    end

    it 'without params[:status]' do
      get :show, params: { id: category.id }
      expect(response).to have_http_status(302)
    end

    it 'with invalid params' do
      get :show, params: { id: category.id, status: 'status' }
      expect(response).to have_http_status(302)
    end

    it 'with valid params' do
      get :show, params: { id: category.id, status: 'opened' }
      expect(response).to have_http_status(200)
      get :show, params: { id: category.id, status: 'closed' }
      expect(response).to have_http_status(200)
      get :show, params: { id: category.id, status: 'pending' }
      expect(response).to have_http_status(200)
      get :show, params: { id: category.id, status: 'declined' }
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #new' do
    let(:action) { get :new }

    it 'when user is not logged in' do
      expect(action).to have_http_status(302)
    end

    it 'when user is a reporter' do
      sign_in reporter
      expect(action).to have_http_status(302)
    end

    it 'when user is moderator' do
      sign_in moderator
      expect(action).to have_http_status(200)
      expect(action).to render_template(:new)
    end

    it 'when user is admin' do
      sign_in admin
      expect(action).to have_http_status(200)
      expect(action).to render_template(:new)
    end
  end

  describe 'POST #create' do
    it 'when user is not logged in' do
      expect do
        post :create, params: { category: category_params }
      end.to change(Category, :count).by(0)
    end

    it 'when user is a reporter' do
      sign_in reporter
      expect do
        post :create, params: { category: category_params }
      end.to change(Category, :count).by(0)
    end

    it 'when user is a moderator' do
      sign_in moderator
      expect do
        post :create, params: { category: category_params }
      end.to change(Category, :count).by(1)
    end

    it 'when user is an admin' do
      sign_in admin
      expect do
        post :create, params: { category: category_params }
      end.to change(Category, :count).by(1)
    end

    it 'doesn\'t create new record with a non-unique name' do
      sign_in admin
      post :create, params: { category: category_params }
      expect do
        post :create, params: { category: category_params }
      end.to change(Category, :count).by(0)
    end
  end

  describe 'GET #edit' do
    it 'returns a 200 OK status and renders template :edit' do
      sign_in admin
      get :edit, params: { id: category.id }
      expect(response).to have_http_status(200)
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    let(:attributes) do
      FactoryGirl.attributes_for(:category, name: 'New name',
                                            description: 'New awesome
                                                          description',
                                            tags: 'new tag pack')
    end

    before(:each) do
      sign_in admin
      patch :update, params: { id: category.id, category: attributes }
      category.reload
    end

    it 'redirects_to action: :index' do
      expect(response).to redirect_to(action: :index)
    end

    it 'changes attributes' do
      expect(category.name).to eql attributes[:name]
      expect(category.description).to eql attributes[:description]
      expect(category.tags).to eql attributes[:tags]
    end
  end

  describe 'DELETE #destroy' do
    let!(:second_category) { create(:category) }
    let!(:issue) { create(:issue, category: second_category) }

    before(:each) do
      sign_in admin
      category
    end

    it 'deletes category' do
      expect do
        delete :destroy, params: { id: category.id }
      end.to change(Category, :count).by(-1)
    end

    it 'returns a 303 See Other status and redirects_to action: :index' do
      delete :destroy, params: { id: category.id }
      expect(response).to have_http_status(303)
      expect(response).to redirect_to(action: :index)
    end

    it 'doesn\'t delete category if it has issues' do
      expect do
        delete :destroy, params: { id: second_category.id }
      end.to change(Category, :count).by(0)
    end
  end
end
