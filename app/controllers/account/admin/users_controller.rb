# Encoding: utf-8
# frozen_string_literal: true
module Account
  module Admin
    class UsersController < ApplicationController
      before_action :admin_or_moderator?, only: [:index, :toggle_ban]
      before_action :admin?, only: [:change_role]

      def index
        @users = User.page(params[:page]).per(20)
      end

      def change_role
        @user = User.find(params[:id])

        if @user.update_attributes(user_params)
          redirect_to request.referer
        else
          redirect_to request.referer, alert: 'Не можу змінити роль'
        end
      end

      def toggle_ban
        @user = User.find(params[:id])
        @user.toggle!(:banned)
        redirect_to request.referer
      end

      private

      def user_params
        params.require(:user).permit(:role)
      end
    end
  end
end
