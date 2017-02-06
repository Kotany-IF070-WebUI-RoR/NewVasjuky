class UsersController < ApplicationController
  before_action :find_user, only: [:show]
  skip_before_action :require_active_user, only: [:show]

  def show
    issue_listing(@user.issues)
  end

  def ranking
    @period = 30
    if params[:period] && [7, 30, 90].include?(params[:period].to_i)
      @period = params[:period].to_i
    end
    @users = User.ranking(@period)
    @categories = Category.ordered_by_name
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
