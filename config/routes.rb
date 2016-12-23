# frozen_string_literal: true
Rails.application.routes.draw do
  devise_scope :user do
    get 'wp-admin', to: 'devise/sessions#new'
  end

  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'home#index'
end
