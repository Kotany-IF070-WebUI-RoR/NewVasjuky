Highcharts.setOptions({
  global: {
    useUTC: false
  },  
  lang: {
    months: ['Січень', 'Лютий', 'Березень', 'Квітень',
             'Травень', 'Червень', 'Липень', 'Серпень',
             'Вересень', 'Жовтень', 'Листопад', 'Грудень'],
    weekdays: ['Неділя', 'Понеділок', 'Вівторок',
               'Середа', 'Четвер', "П'ятниця", 'Субота'],
    shortMonths: ['Січ.', 'Лют.', 'Бер.', 'Квіт.', 'Трав.', 'Черв.',
                  'Лип.', 'Серп.', 'Вер.', 'Жовт.', 'Лист.', 'Груд.'],
    shortWeekdays: ['Нд', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб']
  }
});

Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, function (color) {
    return {
        radialGradient: {
            cx: 0.5,
            cy: 0.3,
            r: 0.7
        },
        stops: [
            [0, color],
            [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
        ]
    };
});

Highcharts.getOptions().legend.labelFormatter = function () {  
  return this.name === 'Створено' ?
    this.name + ' ' + gon.total_calculate :
    this.name === 'З них вирішено' ?
      this.name + ' ' + gon.closed_calculate : this.name
};
