# Encoding: utf-8
# frozen_string_literal: true
module Account
  module Admin
    class UsersController < ApplicationController
      before_action :admin_or_moderator?, only: [:index, :toggle_ban]
      before_action :admin?, only: [:change_role]
      before_action :find_user, only: [:change_role, :toggle_ban]

      def index
        @users_scope = User.all
        @users_scope = user_role_select if params[:user_role]
        @users_scope = @users_scope.like(params[:filter]) if params[:filter]

        smart_listing_create :users,
                             @users_scope,
                             partial: 'account/admin/users/user',
                             default_sort: { created_at: 'asc' }
      end

      def change_role
        if @user.update_attributes(user_params)
          redirect_back(fallback_location: root_path)
        else
          redirect_back(fallback_location: root_path)
          flash[:alert] = 'Не можу змінити роль'
        end
      end

      def toggle_ban

        return unless @user.reporter?
        if @user.banned?
          @user.update_attribute(:ban_reason, '')
        else
          @user.update_attributes(user_params)
        end
        @user.toggle!(:active)
        redirect_back(fallback_location: root_path)
        ban_notice_message
      end

      private

      def ban_notice_message
        if @user.active?
          flash[:notice] = "Користувач #{@user.full_name} розблокований"  
        else
          flash[:notice] = "Користувач #{@user.full_name} заблокований"
        end
      end

      def find_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:role, :ban_reason)
      end

      def user_role_select
        return User.all if params[:user_role].empty?
        @users_scope.role_search(params[:user_role])
      end
    end
  end
end
