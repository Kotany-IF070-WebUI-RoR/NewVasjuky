# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' },
             skip: [:sessions]

  devise_scope :user do
    get 'sign-in', to: 'devise/sessions#new', as: :new_user_session
    post 'sign-in', to: 'devise/sessions#create', as: :user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  namespace :account do
    namespace :admin do
      resources :issues, only: [:index, :edit, :update] do
        member do
          patch :approve, :decline, :close
        end
      end

      resources :users, only: [:index] do
        member do
          patch :toggle_ban
          patch :change_role
        end
      end

      resources :categories
    end
  end

  authenticate :user, ->(u) { u.admin? } do
    mount Resque::Server, at: '/resque'
  end

  resources :categories, only: [:show]

  resources :issues, only: [:new, :index, :create, :show] do
    collection do
      get :map
      get :closed
    end
    member do
      get :popup
      post :upvote
      delete :downvote
    end
    post 'follow',   to: 'issues/socializations#follow'
    post 'unfollow', to: 'issues/socializations#unfollow'
    resources :comments, module: :issues, only: [:create, :index]
  end

  resources :comments, only: [:destroy]
  resources :users, only: [:show] do
    collection do
      get :ranking
    end
  end

  resources :events, only: [:show]

  get  'followees', to: 'issues#followees'
  get  'feed', to: 'feeds#common_feed'
  get  'user_feed', to: 'feeds#user_feed'
  get  'statistics', to: 'common_pages#statistics'
  get  ':page', to: 'pages#show', as: :static_pages
  root to: 'common_pages#home'
end
