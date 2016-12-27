# frozen_string_literal: true
module Account
  class UsersController < ApplicationController
    def index
      @users = User.page(params[:page]).per(20)
      authorize @users
    end

    def change_role
      @user = User.find(params[:id])
      authorize @user

      if @user.update_attributes(user_params)
        redirect_to account_users_path
      else
        redirect_to account_users_path, alert: 'Unable to change role'
      end
    end

    def toggle_ban
      @user = User.find(params[:id])
      authorize @user
      @user.toggle!(:banned)
      redirect_to account_users_path
    end

    private

    def user_params
      params.require(:user).permit(:role)
    end
  end
end
