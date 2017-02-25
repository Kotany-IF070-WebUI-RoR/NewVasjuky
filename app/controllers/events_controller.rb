class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    render partial: 'events/event_details'
  end
end
