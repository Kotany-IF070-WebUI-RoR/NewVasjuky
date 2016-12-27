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
    resources :issues, only: [:index, :destroy] do
      member do
        patch :approve
      end
    end

    resources :users, only: [:index] do
      member do
        patch :toggle_ban
        patch :change_role
      end
    end
  end

  resources :issues, only: [:new, :create]
  root to: 'home#index'
end
