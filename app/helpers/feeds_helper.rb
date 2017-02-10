module FeedsHelper
  def users_feed?
    params[:controller] == 'feeds' && params[:action] == 'user_feed'
  end
end
