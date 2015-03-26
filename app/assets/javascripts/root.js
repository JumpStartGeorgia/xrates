$(function () {

  var prevCurrency = gon.currency;

  $('.tab').click(function(){
    var t = $(this);
    $('.tab').removeClass("active");
    t.addClass("active");
    $('.page.active').removeClass("active");
    $('.page[data-tab-id='+t.attr('data-id')+']').addClass("active");
  });

  $('select.filter-currency').select2({ maximumSelectionSize: 5,
    width:380,
    formatResult: function(d){
      return "<div class='flag'><img src='/assets/png/flags/"+d.id+".png'/></div><div class='abbr'>"+d.id+"</div><div class='name'>"+d.text+"</div>";
    },
    formatSelection: function(d)
    {
      return "<div>"+d.id+"</div>";
    } 
  });
  $('select.filter-bank').select2({ maximumSelectionSize: 5,
    width:380,
    formatResult: function(d){
      return "<div class='logo'><img src='/assets/png/banks/"+$(d.element).attr('data-image')+".png'/></div><div class='abbr'>"+d.id+"</div><div class='name'>"+d.text+"</div>";
    },
    formatSelection: function(d)
    {
      return "<div>"+d.id+"</div>";
    } 
  });

  $('#saving').focusout(function(){
     var t = $(this);
     var v = +t.val().replace(/,/g, '');
     t.val(v.toLocaleString());
  });

  $('button#btnSubmit').click(function(){
    var select = $('select#currency');
    window.location.href = $(this).data('url') + "?currency=" + $(select).val();
  });

   $('.currency-switch > div').click(function(){
      var t = $(this);
      var p = t.parent();
      p.find('> div').removeClass('active');
      t.addClass('active');
      calculate();
   });  
  $('.b_chart_switch > div').click(function(){
    var t = $(this);
    var p = t.parent();
    p.find('> div').removeClass('active');
    t.addClass('active');
     console.log(t.attr('data-chart-type'));
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

  $('.filter-currency, .filter-bank').on('change',function(){
     c_chart_refresh($('.filter-currency').val(), $('.filter-bank').val());
  });



  $.getJSON('/' + I18n.locale + '/nbg?currency=' + gon.currency, function (d) {  
    b_chart(d);
    a_chart();
  });

  if($('#rates').length)
  {
    c_chart(gon.currency,[gon.bank]);
  }

  function calculate(){
     console.log("calculation");
  }
  function c_chart(c,b){
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
  function c_chart_refresh(c, b){ // currency, bank
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
      c_chart(c,b);
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
  function a_chart(){
    $('#a_chart').highcharts({
        chart:
        {
          backgroundColor: '#f1f2f2',
          height: 340
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
  function b_chart(d)
   {
    if(!$('#b_chart').length) return;

      $('#b_chart').highcharts('StockChart', {
           chart:
          {
            backgroundColor: '#f1f2f2'
          },
          rangeSelector: {
              selected: 1,
              inputDateFormat: '%d-%b-%Y',
              inputEditDateFormat: '%d-%b-%Y',
              inputBoxWidth: 120,  
              inputBoxHeight: 20,                  
              inputDateParser:function(v)
              {
                 v = v.split(/-/);
                return Date.UTC(
                    parseInt(v[2], 10),
                    parseInt(v[1], 10)-1,
                    parseInt(v[0], 10),
                    0,0,0,0);              
              }
          },     
          xAxis: { 
            tickColor: '#d7e0e7',  
            lineColor: '#d7e0e7',         
            labels: {
              style: {
                  fontFamily: 'glober-sb',
                  fontSize: '16px'
              }
            }  
          },     
          yAxis: {
              opposite: false,
              gridLineColor: '#ffffff',
              gridLineWidth: 2,             
              plotLines: [{
                  value: 0,
                  width: 2,
                  color: 'silver'
              }],
              labels: 
              {
                style: {
                  color: '#f6ba29',
                  fontFamily: 'glober-sb',
                  fontSize: '16px'
                }
              }
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
            enabled: false,
            // labelFormatter: function()
            // {
            //   return this.name + " (" + this.options.ratio + ")";
            // }
          },
          navigator: {
            maskFill: 'rgba(246, 186, 41, 0.49)',
            handles: {
                backgroundColor: '#f6ba29',
                borderColor: 'black'
            }
          },
          scrollbar: {
            barBackgroundColor: '#e5d7b4',
            barBorderWidth: 0,
            buttonBackgroundColor: '#d5d3cd',
            buttonBorderWidth: 0,
            buttonArrowColor: '#fff',
            rifleColor: '#fff',
            trackBackgroundColor: '#ebeae6',
            trackBorderWidth: 1,


//             barBackgroundColor: #bfc8d1
// barBorderColor: #bfc8d1
// barBorderRadius: 0
// barBorderWidth: 1
// buttonArrowColor: #666
// buttonBackgroundColor: #ebe7e8
// buttonBorderColor: #bbbbbb
// buttonBorderRadius: 0
// buttonBorderWidth: 1
// enabled: true
// height:
// liveRedraw:
// minWidth: 6
// rifleColor: #666
// trackBackgroundColor: #eeeeee
// trackBorderColor: #eeeeee
// trackBorderRadius: 0
// trackBorderWidth: 1
        },

          credits: { enabled: false },
          series: d.rates
      },
      function (chart) {
        setTimeout(function () {
            $('input.highcharts-range-selector', $(chart.container).parent())
                .datepicker({dateFormat: "dd-mm-yy",});
        }, 0);
      }
    );

    // $('#stock').highcharts('StockChart', {

    //   rangeSelector: {
    //       selected: 1
    //   },
    //   title: {
    //       text: d.title
    //   },
    //   yAxis: {        
    //       plotLines: [{
    //           value: 0,
    //           width: 2,
    //           color: 'silver'
    //       }]
    //   },

    //   tooltip: {
    //       pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b><br/>',
    //       valueDecimals: 2
    //   },
    //   legend: {
    //     enabled: true,
    //     labelFormatter: function()
    //     {
    //       return this.name + " (" + this.options.ratio + ")";
    //     }
    //   },
    //   series: d.rates
    // });
  }
});