# Encoding: utf-8
module StatisticsHelper
  def by_time
    line_chart [
      {
        name: 'Створено',
        data: @by_issues_opened
      },
      {
        name: 'Вирішено',
        data: @by_issues_closed
      }
    ], id: 'chart', height: '300px', library: {
      colors: ['#88cece', '#64dd4c'],
      chart: {
        type: 'areaspline'
      },
      yAxis: {
        allowDecimals: false,
        tickInterval: 5
      },
      xAxis: {
        gridLineWidth: 1
      },
      tooltip: {
        pointFormat: '{series.name} скарг: <b>{point.y}</b><br>',
        shared: true,
        crosshairs: true
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

  def by_category_opened
    pie_chart @by_category_opened, height: '400px', library: {
      chart: {
        plotBackgroundColor: nil,
        plotBorderWidth: nil,
        plotShadow: false,
        type: 'pie'
      },
      title: {
        text: 'Статистика нових скарг за період'
      },
      tooltip: {
        pointFormat: 'Скарг: <b>{point.y}</b>'
      },
      plotOptions: {
        pie: {
          startAngle: 0,
          endAngle: 360,
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: true,
            format: '{point.percentage:.1f}%',
            style: {
              color: '#555'
            },
            connectorColor: 'silver'
          }
        }
      }
    }
  end

  def by_category_closed
    pie_chart @by_category_closed, height: '400px', library: {
      chart: {
        plotBackgroundColor: nil,
        plotBorderWidth: nil,
        plotShadow: false,
        type: 'pie'
      },
      title: {
        text: 'Статистика закритих скарг за період'
      },
      tooltip: {
        pointFormat: 'Скарг: <b>{point.y}</b>'
      },
      plotOptions: {
        pie: {
          startAngle: 0,
          endAngle: 360,
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: true,
            format: '{point.percentage:.1f}%',
            style: {
              color: '#555'
            },
            connectorColor: 'silver'
          }
        }
      }
    }
  end
end
