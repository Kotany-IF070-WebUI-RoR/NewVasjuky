# Encoding: utf-8
# frozen_string_literal: true
module Account
  module Admin
    class UsersController < ApplicationController
      before_action :admin_or_moderator?, only: [:index, :toggle_ban]
      before_action :admin?, only: [:change_role]

      def index
        @users_scope = User.all
        @users_scope = user_role_select if params[:user_role]
        @users_scope = @users_scope.like(params[:filter]) if params[:filter]

        smart_listing_create :users,
                             @users_scope,
                             partial: 'account/admin/users/user'
      end

      def change_role
        @user = User.find(params[:id])

        if @user.update_attributes(user_params)
          redirect_back(fallback_location: root_path)
        else
          redirect_back(fallback_location: root_path)
          flash[:alert] = 'Не можу змінити роль'
        end
      end

      def toggle_ban
        @user = User.find(params[:id])

        return unless @user.reporter?
        @user.toggle!(:banned)
        redirect_back(fallback_location: root_path)
        if @user.banned?
          flash[:notice] = "Користувач #{@user.full_name} заблокований"
        else
          flash[:notice] = "Користувач #{@user.full_name} розблокований"
        end
      end

      private

      def user_params
        params.require(:user).permit(:role)
      end

      def user_role_select
        return User.all if params[:user_role].empty?
        @users_scope.role_search(params[:user_role])
      end
    end
  end
end
