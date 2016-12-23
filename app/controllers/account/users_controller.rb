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
  end
end
