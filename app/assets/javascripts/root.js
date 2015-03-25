$(function () {

  $('select.selectpicker').selectpicker();

  $('#saving').focusout(function(){
     
     var t = $(this);
     var v = +t.val().replace(/,/g, '');
     t.val(v.toLocaleString());
  });

  $('button#btnSubmit').click(function(){
    var select = $('select#currency');
    window.location.href = $(this).data('url') + "?currency=" + $(select).val();
  });

  $.getJSON('/' + I18n.locale + '/nbg?currency=' + gon.currency, function (d) {  
    initCharts(d);
  });
  if($('#rates').length)
  {
    initChartC(gon.currency,[gon.bank]);
  }



   $(document).on('click','.bootstrap-select button.dropdown-toggle .filter-option button', function(){
     $('.bootstrap-select ul.dropdown-menu li a > div button[data-id=' + $(this).attr('data-id') + ']').closest('a').trigger('click');
   });

  
   $('.currency-switch > div').click(function(){
      var t = $(this);
      var p = t.parent();
      p.find('> div').removeClass('active');
      t.addClass('active');
      calculate();
   });   


   $.datepicker.setDefaults( $.datepicker.regional[ I18n.locale ] );
   $('.calculator .from[data-type=datepicker]').datepicker({
      dateFormat: "d M, yy",
      defaultDate: "-3m",
      onClose: function( v ) {
        $('.calculator .to[data-type=datepicker]').datepicker( "option", "minDate", v );
      }
   }).datepicker('setDate', "-3m");

   $('.calculator .to[data-type=datepicker]').datepicker({
      dateFormat: "d M, yy",
      defaultDate: "d",
      onClose: function( v ) {
        $('.calculator .from[data-type=datepicker]').datepicker( "option", "maxDate", v );
      }
   }).datepicker('setDate', "d");


  function calculate()
  {
     console.log("calculation");
  }

   function initCharts(d)
   {
    if(!$('#stock').length) return;

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


var prevCurrency = gon.currency;

  $('.filter-currency, .filter-bank').on('change',function(){
     refreshChartC($('.filter-currency').val(), $('.filter-bank').val());
  });

  function refreshChartC(c, b) // currency, bank
  {    
    var chart = $('#rates').highcharts();

    if(c != prevCurrency)
    {

      prevCurrency = c;
      // while(chart.series.length > 0)
      // {
      //   chart.series[0].remove(false);
      // }
      // chart.redraw();
      chart.destroy();
      if(b === null || b === "") b = ["1"];
      else b.unshift("1");
      initChartC(c,b);
    }
    else
    {
      if(b === null) b = [];
      var toDelete = [];
      chart.series.forEach(function(d){
        if(d.options.id !== "highcharts-navigator-series" && d.options.id !== "b_1" && b.indexOf(d.options.id.replace('b_','').replace('b_buy_','').replace('b_sell_','')) === -1)
        {
          toDelete.push(d.options.id);
        }
      });
      toDelete.forEach(function(d){
        chart.get(d).remove(false);
      });


      //console.log('rates?currency=' + c + "&bank="+ b.join(','));
      if(c !== null && b !== null)
      {
        $.getJSON('/' + I18n.locale + '/rates?currency=' + c + "&bank="+ b.join(','), function (d) {
          d.rates.forEach(function(t,i){
            var ser = chart.get(t.id);
             if(ser === null)
             {  
                chart.addSeries(t,false,false);
             }     
          });      
          chart.redraw();
        });
      }
    }
  }

  function initChartC(c,b)
  {

  $.getJSON('/' + I18n.locale + '/rates?currency=' + c + "&bank=" + b.join(','), function (d) {
   //console.log(d);
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
          legend: {
            enabled: true   
          },
          series: d.rates
      });
    });
  }
    yourChart();
  function yourChart()
  {
      $('#your_chart').highcharts({
        chart:
        {
          backgroundColor: '#f1f2f2'
        },
        title: {
            text: 'Monthly Average Temperature',
            align: 'left',
            margin: 50,
            useHTML: true,
            style:
            {
              fontFamily: 'glober-sb',
              fontSize: '24px',
              color:'#7b8483',
              borderBottom: '1px solid #7b8483',
              paddingBottom: '3px'
            },
            x: 30,
            y: 30
        },    
        xAxis: {
            categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            labels: {
              style: {
                  fontFamily: 'glober-sb',
                  fontSize: '16px'
              }
            }  
        },
        yAxis: {
            gridLineColor: '#ffffff',
            gridLineWidth: 2,
            title: {
                text: 'USD',
                rotation: 0,
                margin:20,
                style:
                {
                  fontFamily: 'glober-sb',
                  fontSize: '19px',
                  color:'#7b8483',
                }
            },
            labels: {
              style: {
                  paddingBottom: '20px',
                  color: '#f6ba29',
                  fontFamily: 'glober-sb',
                  fontSize: '16px'
              }
            }
        },
        legend: {
          enabled: false
        },
 
        series: [{
            name: 'Tokyo',
            data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6],
            color: '#f6ba29'
        }]
    });
  }

  $('.tab').click(function(){
    var t = $(this);
    $('.tab').removeClass("active");
    t.addClass("active");
    $('.page.active').removeClass("active");
    $('.page[data-tab-id='+t.attr('data-id')+']').addClass("active");
  });
});