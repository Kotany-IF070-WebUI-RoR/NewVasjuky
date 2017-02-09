# frozen_string_literal: true
class CommonPagesController < ApplicationController
  include Feed
  skip_before_action :authenticate_user!, :require_active_user,
                     only: [:home, :feed]

  def home
    @issues_feed = Issue.approved.ordered.limit(4)
    @count = Issue.approved.count
    @closed_count = Issue.closed.count
  end

  def feed
    @events = Event.ordered.public_events.page(params[:page]).per(10)
    respond_for_feed(@events)
  end
end
