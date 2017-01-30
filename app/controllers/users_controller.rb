class UsersController < ApplicationController
  before_action :find_user, only: [:show]
  skip_before_action :require_active_user, only: [:show]

  def show
    issue_listing(@user.issues)
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
