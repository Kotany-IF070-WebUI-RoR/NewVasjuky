module Statistics
  extend ActiveSupport::Concern

  def dates_and_ranges
    @start = DateTime.parse('2015-01-01').in_time_zone
    @one_month = 1.month.ago..Time.zone.now
    @one_year = 1.year.ago..Time.zone.now
    @from_start = @start..Time.zone.now
  end

  def period
    dates_and_ranges
    return @one_month if params[:period] == 'month'
    if params[:period] == 'year'
      return 1.year.ago < @start ? @from_start : @one_year
    end
    return @from_start if params[:period] == 'total'
    @one_month
  end

  def day_range
    ((period.last - period.first) / 1.day).ceil
  end

  def group_by
    day_range
    return :day if day_range < 60
    return :month if day_range < 367
    return :quarter if Rails.env.production?
    :week
  end
end
