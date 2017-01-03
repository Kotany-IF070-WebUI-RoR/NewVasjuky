# Encoding: utf-8
# frozen_string_literal: true
module Account
  module Admin
    class UsersController < ApplicationController
      def index
        @users = User.page(params[:page]).per(20)
        authorize @users
      end

      def change_role
        @user = User.find(params[:id])
        authorize @user

        if @user.update_attributes(user_params)
          redirect_to request.referrer
        else
          redirect_to request.referrer, alert: 'Не можу змінити роль'
        end
      end

      def toggle_ban
        @user = User.find(params[:id])
        authorize @user
        @user.toggle!(:banned)
        redirect_to request.referrer
      end

      private

      def user_params
        params.require(:user).permit(:role)
      end
    end
  end
end
