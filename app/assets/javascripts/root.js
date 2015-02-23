$(function () {

  $('select#currency').change(function(){
    window.location.href = $(this).data('url') + "?currency=" + $(this).val();
  });

  $('#chart').highcharts({
      chart: {
          zoomType: 'x'
      },
      title: {
          text: gon.title
      },
      subtitle: {
          text: document.ontouchstart === undefined ?
                  'Click and drag in the plot area to zoom in' :
                  'Pinch the chart to zoom in'
      },
      xAxis: {
          type: 'datetime',
          minRange: 14 * 24 * 3600000 // fourteen days
      },
      yAxis: {
          title: {
              text: gon.yaxis
          }
      },
      legend: {
          enabled: false
      },
      plotOptions: {
          area: {
              fillColor: {
                  linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1},
                  stops: [
                      [0, Highcharts.getOptions().colors[0]],
                      [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                  ]
              },
              marker: {
                  radius: 2
              },
              lineWidth: 1,
              states: {
                  hover: {
                      lineWidth: 1
                  }
              },
              threshold: null
          }
      },

      series: [{
          type: 'area',
          name: gon.popup,
          pointInterval: 24 * 3600 * 1000,
          pointStart: Date.UTC(gon.start_date_year, gon.start_date_month, gon.start_date_day),
          data: gon.rates
      }]
  });
});