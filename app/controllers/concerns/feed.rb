module Feed
  def respond_for_feed(events)
    if request.xhr?
      response.headers['TotalPages'] = events.total_pages
      render partial: 'events/event_list'
    else
      render 'shared/feed'
    end
  end
end
