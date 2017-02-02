# frozen_string_literal: true
module NotificationsHelper
  def users_feed?
    params[:controller] == 'users'
  end

  def unread?(event)
    current_user.unread_notification_for(event) if users_feed? && event.present?
  end
end
