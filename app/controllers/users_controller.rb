class UsersController < ApplicationController
  include Feed
  before_action :find_user, only: [:show]
  skip_before_action :require_active_user, only: [:show, :ranking]
  skip_before_action :authenticate_user!, only: [:ranking]

  def show
    issue_listing(@user.issues)
  end

  def feed
    current_user.check_notifications unless request.xhr?
    @events = current_user.events.ordered.page(params[:page]).per(3)
    respond_for_feed(@events)
    read_notifications_for_loaded_events
  end

  def ranking
    @period = params[:period] || 30
    @period = @period.to_i if [7, 30, 90].include?(@period.to_i)
    @users = User.top_ranking_for(@period)
    @categories = Category.ordered_by_name
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def read_notifications_for_loaded_events
    notifications = current_user.unread_notifications_for(@events)
    notifications.update_all(readed: true)
  end
end
