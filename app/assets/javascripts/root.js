$(function () {

  $('select.selectpicker').selectpicker();

  $('button#btnSubmit').click(function(){
    var select = $('select#currency');
    window.location.href = $(this).data('url') + "?currency=" + $(select).val();
  });

  $.getJSON('nbg?currency=' + gon.currency, function (d) {
     console.log(d);
   initCharts(d);
  });
 

$.getJSON('rates?currency=' + gon.currency + "&bank=" + gon.bank, function (d) {
  $('#rates').highcharts('StockChart', {
          rangeSelector: {
              selected: 1
          },
          // title: {
          //     text: 'ads'//d.title
          // },
          // yAxis: {
          //     labels: {
          //         formatter: function () {
          //             return (this.value > 0 ? ' + ' : '') + this.value + '%';
          //         }
          //     },
          //     plotLines: [{
          //         value: 0,
          //         width: 2,
          //         color: 'silver'
          //     }]
          // },

          // plotOptions: {
          //     series: {
          //         compare: 'percent'
          //     }
          // },

          // tooltip: {
          //     pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.change}%)<br/>',
          //     valueDecimals: 2
          // },
          // legend: {
          //   enabled: true,
          //   labelFormatter: function()
          //   {
          //     return this.name + " (" + this.options.ratio + ")";
          //   }
          // },
          series: d.rates
      });
  });

   $(document).on('click','.bootstrap-select button.dropdown-toggle .filter-option button', function(){
     $('.bootstrap-select ul.dropdown-menu li a > div button[data-id=' + $(this).attr('data-id') + ']').closest('a').trigger('click');
   });

  
    $('#rates').highcharts('StockChart', {
          rangeSelector: {
              selected: 1
          },
          // title: {
          //     text: 'ads'//d.title
          // },
          // yAxis: {
          //     labels: {
          //         formatter: function () {
          //             return (this.value > 0 ? ' + ' : '') + this.value + '%';
          //         }
          //     },
          //     plotLines: [{
          //         value: 0,
          //         width: 2,
          //         color: 'silver'
          //     }]
          // },

          // plotOptions: {
          //     series: {
          //         compare: 'percent'
          //     }
          // },

          // tooltip: {
          //     pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.change}%)<br/>',
          //     valueDecimals: 2
          // },
          // legend: {
          //   enabled: true,
          //   labelFormatter: function()
          //   {
          //     return this.name + " (" + this.options.ratio + ")";
          //   }
          // },
          series: [{}]
      });

  
   function initCharts(d)
   {
      $('#stock-percent').highcharts('StockChart', {
          rangeSelector: {
              selected: 1
          },
          title: {
              text: d.title
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
          legend: {
            enabled: true,
            labelFormatter: function()
            {
              return this.name + " (" + this.options.ratio + ")";
            }
          },

          series: d.rates
      });

    $('#stock').highcharts('StockChart', {

      rangeSelector: {
          selected: 1
      },
      title: {
          text: d.title
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
      legend: {
        enabled: true,
        labelFormatter: function()
        {
          return this.name + " (" + this.options.ratio + ")";
        }
      },
      series: d.rates
    });
  }




  $('.filter-currency, .filter-bank').on('change',function(){
     refreshChartC($('.filter-currency').val(), $('.filter-bank').val());
  });
  function refreshChartC(c, b) // currency, bank
  {
    if(c != "" && b != "")
    {
      $.getJSON('rates?currency=' + c + "&bank="+ b.join(','), function (d) {
         console.log(d);
        var rates = $('#rates').highcharts();
         console.log(rates.series);
        //rates.series.setData(d.rates);
      });
    }
  }
});