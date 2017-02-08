# frozen_string_literal: true
class StaticPagesController < ApplicationController
  helper StatisticsHelper
  skip_before_action :authenticate_user!, :require_active_user,
                     only: [:home, :feed, :statistics]

  def home
    @issues_feed = Issue.approved.ordered.limit(4)
    @count = Issue.approved.count
    @closed_count = Issue.closed.count
  end

  def feed
    @events = Event.ordered.public_events.page(params[:page]).per(10)
  end

  def statistics
    @issues = Issue.opened
  end
end
