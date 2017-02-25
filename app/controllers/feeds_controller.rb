class FeedsController < ApplicationController
  after_action :mark_as_read_loaded, only: [:user_feed]
  skip_before_action :require_active_user, only: [:user_feed, :common_feed]
  skip_before_action :authenticate_user!, only: [:common_feed]

  def user_feed
    current_user.check_notifications unless request.xhr?
    @events = current_user.events.ordered.page(params[:page]).per(3)
    respond_for_feed(@events)
  end

  def common_feed
    @events = Event.ordered.public_events.page(params[:page]).per(5)
    respond_for_feed(@events)
  end

  private

  def mark_as_read_loaded
    return unless request.xhr?
    notifications = current_user.unread_notifications_for(@events)
    notifications.update_all(readed: true)
  end

  def respond_for_feed(events)
    if request.xhr?
      response.headers['TotalPages'] = events.total_pages
      render partial: 'feeds/events/event_list'
    else
      render 'feeds/feed'
    end
  end
end
