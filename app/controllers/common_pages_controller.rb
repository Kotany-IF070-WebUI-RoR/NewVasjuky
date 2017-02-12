# frozen_string_literal: true
class CommonPagesController < ApplicationController
  helper StatisticsHelper
  include Statistics
  before_action :status_inspector, only: [:statistics]
  skip_before_action :authenticate_user!, :require_active_user,
                     only: [:home, :statistics]

  def home
    @issues_feed = Issue.approved.ordered.limit(4)
    @count = Issue.approved.count
    @closed_count = Issue.closed.count
  end

  def statistics
    @by_time_total = Issue.statistics_for(period, group_by,
                                          %w(opened closed))
    @by_time_closed = Issue.statistics_for(period, group_by, 'closed')

    @by_category_opened = Category.statistics_for(day_range,
                                                  %w(opened closed))
    @by_category_closed = Category.statistics_for(day_range,
                                                  %w(closed))
    calculate
  end

  private

  def calculate
    gon.total_calculate = @by_time_total.values.sum
    gon.closed_calculate = @by_time_closed.values.sum
  end

  def status_inspector
    redirect_to statistics_path(period: 'month', sort: 'time') unless
      %w(month year total).include?(params[:period]) &&
      %w(time category).include?(params[:sort])
  end
end
