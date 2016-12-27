# frozen_string_literal: true
module Account
  class UsersController < ApplicationController
    def index
      @users = User.page(params[:page]).per(20)
      authorize @users
    end

    def new; end

    def create; end

    def edit; end

    def update; end

    def destroy; end

    def toggle_ban
      @user = User.find(params[:id])
      @user.toggle!(:banned)
      redirect_to account_users_path
    end
  end
end
