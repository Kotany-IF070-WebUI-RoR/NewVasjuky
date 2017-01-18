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
      resources :issues, only: [:index, :destroy, :edit, :update] do
        member do
          patch :approve, :decline
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

  resources :issues, only: [:new, :index, :create, :show] do
    resources :comments, module: :issues, only: :create
  end

  resources :comments, only: [:destroy]

  root to: 'home#index'
end
