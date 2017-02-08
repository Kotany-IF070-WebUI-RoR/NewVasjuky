# frozen_string_literal: true
class StaticPagesController < ApplicationController
  helper StatisticsHelper
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
    @period = case params[:period]
              when 'month' then 1.month.ago..Time.zone.now
              when 'year'
                case
                when 1.year.ago < '2017-01-02' then '2017-01-02'..Time.zone.now
                else 1.year.ago..Time.zone.now
                end
              when 'total' then '2017-01-02'..Time.zone.now
              else 1.month.ago..Time.zone.now
              end
    @opened = Issue.statistics_for(@period, 'opened')
    @closed = Issue.statistics_for(@period, 'closed')
  end

  private

  def status_inspector
    redirect_to statistics_path(period: 'month') unless
      %w(month year total).include?(params[:period])
  end
end
