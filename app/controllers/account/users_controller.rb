# frozen_string_literal: true
module Account
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
      @users = User.page(params[:page]).per(20)
      authorize @users
    end

    def new
      @user = User.new
      authorize @user
    end

    def create
      @user = User.new(user_params)
      authorize @user
      @user.role = :moderator
      if @user.save
        flash[:info] = 'Moderator created!'
        redirect_to account_users_path
      else
        render 'new'
      end
    end

    def edit; end

    def update; end

    def destroy
      @user = resource
      authorize @user
      @user.destroy
      redirect_to account_users_path, notice: 'User was successfully destroyed.'
    end

    private

    def resource
      User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  end
end
