# frozen_string_literal: true
class UsersController < ApplicationController
  def index
    @users = User.all
    authorize @users
  end

  def show; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end
end
