$(function () {

  $('select.selectpicker').selectpicker();

  $('button#btnSubmit').click(function(){
    var select = $('select#currency');
    window.location.href = $(this).data('url') + "?currency=" + $(select).val();
  });

  // $('#chart').highcharts({
  //     chart: {
  //         zoomType: 'x'
  //     },
  //     title: {
  //         text: gon.chart_title
  //     },
  //     subtitle: {
  //         text: document.ontouchstart === undefined ?
  //                 'Click and drag in the plot area to zoom in' :
  //                 'Pinch the chart to zoom in'
  //     },
  //     xAxis: {
  //         type: 'datetime',
  //         minRange: 14 * 24 * 3600000 // fourteen days
  //     },
  //     yAxis: {
  //         title: {
  //             text: gon.chart_yaxis
  //         }
  //     },
  //     legend: {
  //         enabled: false
  //     },
  //     plotOptions: {
  //         area: {
  //             fillColor: {
  //                 linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1},
  //                 stops: [
  //                     [0, Highcharts.getOptions().colors[0]],
  //                     [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
  //                 ]
  //             },
  //             marker: {
  //                 radius: 2
  //             },
  //             lineWidth: 1,
  //             states: {
  //                 hover: {
  //                     lineWidth: 1
  //                 }
  //             },
  //             threshold: null
  //         }
  //     },

  //     series: [{
  //         type: 'area',
  //         name: gon.chart_popup,
  //         pointInterval: 24 * 3600 * 1000,
  //         pointStart: Date.UTC(gon.chart_start_date_year, gon.chart_start_date_month, gon.chart_start_date_day),
  //         data: gon.chart_rates
  //     }]
  // });


  $('#stock-percent').highcharts('StockChart', {

      rangeSelector: {
          selected: 1
      },
      title: {
          text: gon.stock_title
      },
      yAxis: {
          labels: {
              formatter: function () {
                  return (this.value > 0 ? ' + ' : '') + this.value + '%';
              }
          },
          plotLines: [{
              value: 0,
              width: 2,
              color: 'silver'
          }]
      },

      plotOptions: {
          series: {
              compare: 'percent'
          }
      },

      tooltip: {
          pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.change}%)<br/>',
          valueDecimals: 2
      },

      series: gon.stock_rates
  });

   $('#stock').highcharts('StockChart', {

      rangeSelector: {
          selected: 1
      },
      title: {
          text: gon.stock_title
      },
      yAxis: {        
          plotLines: [{
              value: 0,
              width: 2,
              color: 'silver'
          }]
      },

      tooltip: {
          pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b><br/>',
          valueDecimals: 2
      },

      series: gon.stock_rates
  });

   $(document).on('click','.bootstrap-select button.dropdown-toggle .filter-option button', function(){
     $('.bootstrap-select ul.dropdown-menu li a > div button[data-id=' + $(this).attr('data-id') + ']').closest('a').trigger('click');
   });

});