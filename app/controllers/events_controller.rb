class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    if current_user.can_get_details_of?(@event)
      render partial: 'events/event_details'
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
