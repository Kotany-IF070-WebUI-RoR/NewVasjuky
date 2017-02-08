# frozen_string_literal: true
module NotificationsHelper
  def users_feed?
    params[:controller] == 'users'
  end
end
