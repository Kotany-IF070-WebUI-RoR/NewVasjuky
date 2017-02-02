module Feed
  def respond_for_feed(events)
    if request.xhr?
      render_xhr_response_for_feed(events)
    else
      render 'shared/feed'
    end
  end

  def render_xhr_response_for_feed(events)
    if events.any?
      render partial: 'events/event_list'
    else
      render plain: 'end_of_list'
    end
  end
end
