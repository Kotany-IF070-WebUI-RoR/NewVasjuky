# frozen_string_literal: true
class StaticPagesController < ApplicationController
  helper StatisticsHelper
  include Statistics
  before_action :status_inspector, only: [:statistics]
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
    @by_issues_opened = Issue.statistics_for(period, group_by, 'opened')
    @by_issues_closed = Issue.statistics_for(period, group_by, 'closed')

    @by_category_opened = Category.statistics_for(day_range, 'opened')
                                  .transform_keys { |key| Category.find(key).name }
    @by_category_closed = Category.statistics_for(day_range, 'closed')
                                  .transform_keys { |key| Category.find(key).name }
  end

  private

  def status_inspector
    redirect_to statistics_path(period: 'month') unless
      %w(month year total).include?(params[:period])
  end
end
