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
    end
    post 'follow',   to: 'issues/socializations#follow'
    post 'unfollow', to: 'issues/socializations#unfollow'
    resources :comments, module: :issues, only: :create
    member do
      post 'upvote'
    end
  end

  resources :comments, only: [:destroy]
  resources :users, only: [:show] do
    collection do
      get :ranking
    end
  end

  get  'followees', to: 'issues#followees'
  get  'feed', to: 'issues_feeds#feed'
  get  ':page', to: 'pages#show'
  root to: 'issues_feeds#home'
end
