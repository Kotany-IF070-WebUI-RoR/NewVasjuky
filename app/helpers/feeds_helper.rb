module FeedsHelper
  def users_feed?
    params[:controller] == 'feeds' && params[:action] == 'user_feed'
  end

  def common_feed?
    params[:controller] == 'feeds' && params[:action] == 'common_feed'
  end
end
