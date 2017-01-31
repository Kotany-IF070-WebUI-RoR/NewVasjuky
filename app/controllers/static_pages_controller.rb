# frozen_string_literal: true
class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :require_active_user, only: [:home]

  def home
    @issues = Issue.approved.ordered
    @issues_feed = @issues.first(4)
    @count = Issue.approved.count
    @closed_count = Issue.closed.count
  end

  def feed
    @events = Event.ordered.public_events.page(params[:page]).per(10)
  end

end
