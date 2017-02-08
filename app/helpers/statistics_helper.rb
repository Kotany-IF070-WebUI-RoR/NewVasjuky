# Encoding: utf-8
module StatisticsHelper
  def issues_by_day
    line_chart [
      {
        name: 'Створено',
        data: @total.group_by_day(:created_at,
                                  range: 1.month.ago..Time.zone.now).count
      },
      {
        name: 'Вирішено',
        data: @closed.group_by_day(:created_at,
                                   range: 1.month.ago..Time.zone.now).count
      }
    ], id: 'chart', height: '300px', library: {
      colors: ['#88cece', '#64dd4c'],
      chart: {
        type: 'areaspline'
      },
      yAxis: {
        title: {
          text: 'Кількість'
        },
        allowDecimals: false,
        tickInterval: 5
      },
      xAxis: {
        title: {
          text: 'Дата'
        },
        gridLineWidth: 1
      },
      tooltip: {
        pointFormat: '{series.name} скарг: <b>{point.y}</b><br>',
        shared: true,
        crosshairs: true
      },
      legend: {
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'top',
        x: -40,
        y: 40,
        floating: true,
        borderWidth: 1,
        backgroundColor: '#FFFFFF',
        shadow: true
      },
      plotOptions: {
        series: {
          cursor: 'pointer',
          marker: {
            lineWidth: 1
          }
        }
      }
    }
  end
end
