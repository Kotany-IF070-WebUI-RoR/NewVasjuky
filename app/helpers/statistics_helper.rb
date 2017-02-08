# Encoding: utf-8
module StatisticsHelper
  def issues_by_day
    area_chart @issues.group_by_day(
      :created_at, range: 1.month.ago..Time.zone.now
    ).count, id: 'chart', height: '300px', library: {
      title: { text: 'Кількість поданих скарг' },
      chart: {
        maxWidth: 900
      },
      yAxis: {
        allowDecimals: false,
        title: {
          text: 'Кількість'
        }
      },
      xAxis: {
        startOfWeek: 1,
        type: 'datetime',
        title: {
          text: 'Дата'
        }
      },
      tooltip: {
        pointFormat: 'Скарг: <b>{point.y}</b>'
      }
    }
  end
end
