$(function () {

  var prevCurrency = gon.currency;
  var params = { p: 1 };  
  var cur = { p1: {}, p2: { c: ['USD','EUR','GBP','RUB'] }, p3: { c: ['USD'] , b: ['BNLN'] } }; 
   
  var prev_b_chart_currency = [];
  var b_chart_type = 0; // 0 - none, 1 - percent


  var from = $('.calculator .from[data-type=datepicker]');
  var to = $('.calculator .to[data-type=datepicker]');
  var worth = $('#worth').on('keyup', function() {debounce(calculate(), 500)});
  var worth_then = $('#worth_then .value');
  var worth_now = $('#worth_now .value');
  var rate_then = $('#rate_then .value');
  var rate_now = $('#rate_now .value');
  var worth_diff =  $('#worth_diff .value');
  var info_text = $('#info_text');

  var data = {
    rates:[],
    dir:1,
    date_from:null,
    date_to:null,
    rate_from_init:0,
    rate_to_init:0,
    worth:1,
    nbg: { currencies: [], rates_by_currency: {} }
  };

  $('.tab[data-id] a').click(function(){
    var t = $(this).parent();
    $('.tab').removeClass("active");
    t.addClass("active");
    $('.page.active').removeClass("active");
    $('.page[data-tab-id='+t.attr('data-id')+']').addClass("active");
    params.p = +t.attr('data-id');
  });

  $('select.filter-b-currency').select2({ maximumSelectionSize: 5,
    width:380,
    formatResult: function(d){
      return "<div class='flag'><img src='/assets/png/flags/"+d.id+".png'/></div><div class='abbr'>"+d.id+"</div><div class='name'>"+d.text+"</div>";
    },
    formatSelection: function(d)
    {
      return "<div>"+d.id+"</div>";
    } 
  });

  $('select.filter-c-currency').select2({ maximumSelectionSize: 1,
    width:380,
    formatResult: function(d){
      return "<div class='flag'><img src='/assets/png/flags/"+d.id+".png'/></div><div class='abbr'>"+d.id+"</div><div class='name'>"+d.text+"</div>";
    },
    formatSelection: function(d)
    {
      return "<div>"+d.id+"</div>";
    } 
  });

  $('select.filter-c-bank').select2({ maximumSelectionSize: 5,
    width:380,
    formatResult: function(d){
      return "<div class='logo'><img src='/assets/png/banks/small/"+$(d.element).attr('data-image')+".jpg'/></div><div class='abbr'>"+d.id+"</div><div class='name'>"+d.text+"</div>";
    },
    formatSelection: function(d)
    {
      return "<div>"+d.id+"</div>";
    } 
  });

  $('#worth').focusout(function(){
     var t = $(this);
     var v = +t.val().replace(/,/g, '');
     t.val(v.toLocaleString());
  });

  $('.currency-switch > div').click(function(){
      var t = $(this);
      if(t.hasClass('active')) return;
      var p = t.parent();
      p.find('> div').removeClass('active');
      t.addClass('active');
      $(".calculator .symbol").toggleClass('gel usd');
      
      data.dir = t.attr('data-option') == 'GEL' ? 1 : 0;

      $(".hsw .text").find('.from-value').text(data.dir == 1 ? 'GEL' : 'USD')
      $(".hsw .text").find('.to-value').text(data.dir == 1 ? 'USD' : 'GEL');
      calculate(false);
  });  

  $('.b_chart_switch > div').click(function(){
    var t = $(this);
    var p = t.parent();
    p.find('> div').removeClass('active');
    t.addClass('active');
    var chart = $('#b_chart').highcharts();
    b_chart_type = t.attr('data-compare') == 'none' ? 0 : 1;
    chart.yAxis[0].setCompare(t.attr('data-compare'));
  }); 

   $.datepicker.setDefaults( $.datepicker.regional[ I18n.locale ] );
   $('.calculator .from[data-type=datepicker]').datepicker({
      dateFormat: "d M, yy",
      defaultDate: "-3m",
      onClose: function( v ) {
        $('.calculator .to[data-type=datepicker]').datepicker( "option", "minDate", v );
      },
      onSelect: function(v,o) {
        if($(this).datepicker("getDate").getTime() != data.date_from)
        {
          calculate(true);
        }
      },
   }).datepicker('setDate', "-3m");

   $('.calculator .to[data-type=datepicker]').datepicker({
      dateFormat: "d M, yy",
      defaultDate: "d",
      onClose: function( v ) {
        $('.calculator .from[data-type=datepicker]').datepicker( "option", "maxDate", v );
      },
      onSelect: function() {
        if($(this).datepicker("getDate").getTime() != data.date_to)
        {
          calculate(true);
        }
      }
   }).datepicker('setDate', "d");

  $('.filter-c-currency, .filter-c-bank').on('change',function(){ c_chart_refresh();});

  $('.filter-b-currency').on('change',function(){ b_chart_refresh(); });

  function init()
  {
    if(paramsRead())
    {
      if(exist(params.p))
      {        
        $('.tab[data-id=' + params.p + '] a').trigger('click');
        if(params.p == 2 && exist(params.c))
        {
          cur.p2.c = params.c.split(',');
          console.log('second page');
          return;
        }
        else if(params.p == 3 && exist(params.c) && exist(params.b))
        { 
          console.log('third page');
          return;
        }        

      }

    }
    init_default();
  }
  function init_default()
  {
    console.log('default');
    calculate(true);
    b_chart();
    c_chart();
  }

  function calculate(remote)
  {
    data.worth = getWorth();
    if(data.worth > 0)
    {      
      if(remote)
      {
        data.date_from = from.datepicker("getDate").getTime();
        data.date_to = to.datepicker("getDate").getTime();
        
        var cur_to = $('#currency_switch > div:not(.active)').attr('data-option');

        $.getJSON('/' + I18n.locale + '/nbg?currency=USD&start_date=' + data.date_from+ '&end_date=' + data.date_to, function (d) {      
          if(d.valid)
          {
            data.rates = d.result[0].rates;
            data.rate_from_init = data.rates[0][1];
            data.rate_to_init = data.rates[data.rates.length-1][1];
            output();
          }
        });  
      }
      else
      {
        output();
      }
    }
    else
    {
      worth_then.text('');
      worth_now.text('');
      rate_now.text('');
      rate_then.text('');
      worth_diff.text('');
    }  
  }
  

  function output(){  
    var rate_from = data.rate_from_init;
    var rate_to = data.rate_to_init;
    var text = $("<div>" + gon.info_usd + "</div>");
    if(data.dir == 1)
    {
      rate_from = (1/rate_from).toFixed(4);
      rate_to = (1/rate_to).toFixed(4);
      text = $("<div>" + gon.info_gel  + "</div>");
    }
    var old_worth = data.worth * rate_from;
    var new_worth = data.worth * rate_to;
    rate_then.text(reformat(rate_from,4));
    rate_now.text(reformat(rate_to,4));
    worth_then.text(reformat(old_worth));
    worth_now.text(reformat(new_worth));
    var diff = old_worth - new_worth;
    var inc_dec = "";

    inc_dec = new_worth > old_worth ? gon.increased : gon.decreased;    
    text.find('.up').text(inc_dec);
    $('.diff .label .up').text(inc_dec);

    var info_value = data.dir == 1 ? 
        Math.abs(5200000000 - 5200000000 * data.rate_from_init/ data.rate_to_init)
      : Math.abs(5200000000*data.rate_from_init - 5200000000*data.rate_to_init);

    text.find('.value').text(reformat(info_value,0));
    info_text.html(text);

    worth_diff.text(reformat(Math.abs(diff)));

    a_chart();
  }
  function reformat(n,s){
    s = typeof s === 'number' ? s : 2;
    n = +n;
    return (+n.toFixed(s)).toLocaleString();
  }
  function getWorth(){
    var t = parseFloat(worth.val().replace(/,|\s/g, ''));
    return isNaN(t) ? 0 : t;
  }

  function a_chart(){

    var chart = $('#a_chart').highcharts();

    var worths = [];
    data.rates.forEach(function(d){
      var r = (data.dir == 0 ? d[1] : +(1/d[1]).toFixed(4)).toFixed(2);
      worths.push({ x: d[0], y: (r * data.worth), rate:r, dir: (data.dir==0 ? 'gel' : 'usd') })
    });           

     if(typeof chart === 'undefined')
     {
          $('#a_chart').highcharts({
            chart:
            {
              backgroundColor: '#f1f2f2',
              height: 340
            },
            title: {
                text: gon.a_chart_title,
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
                labels: {
                  style: {
                      fontFamily: 'glober-sb',
                      fontSize: '16px'
                  }
                },
                type: 'datetime' 
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
             plotOptions: {
                series: {
                    marker : {
                      enabled : false,
                      radius : 3,
                      symbol: 'circle'
                    }
                }
            },
            legend: {
              enabled: false
            },
            credits:
            {
              enabled: false
            },
            tooltip: {
              headerFormat: '<span class="tooltip-header">{point.key}</span><br/>', 
              pointFormat: '<div class="tooltip-content"><span>'+gon.rate+'</span>: {point.rate} <span class="symbol {point.dir}"></span><br/><span>'+gon.monetary_value+'</span>: {point.y} <span class="symbol {point.dir}"></span></div>',
              useHTML: true
            },
            series: [{ 
              id:'a1', data: worths, color: '#f6ba29'
            }]    
        });
     }
     else
     {
        chart.yAxis[0].update({
            title:{
              text: (data.dir == 1 ? 'USD' : 'GEL')
            }
        });

        chart.get('a1').remove(false);
        chart.addSeries({ id:'a1', data: worths, color: '#f6ba29',
              marker : {
                enabled : true,
                radius : 3,
                symbol: 'circle'
              } 
            },false,false);
        chart.redraw();                        
     } 
  }  
  function b_chart_refresh(first){
    var chart = $('#b_chart').highcharts();
    var c = $('.filter-b-currency').select2('val');
    cur.p2.c = c;
    if(!first) paramsWrite('c',c);

    prev_b_chart_currency.forEach(function(t){
      if(c.indexOf(t)==-1)
      {
        chart.get(t).remove(false);
      }
    });

    var remote_cur = [];
    var local_cur = [];
    c.forEach(function(t){
      if(data.nbg.currencies.indexOf(t) == -1)
        remote_cur.push(t);
      else local_cur.push(t);
    });    
    if(remote_cur.length)
    {
      $.getJSON('/' + I18n.locale + '/nbg?currency=' + remote_cur.join(','), function (d) { 
        if(d.valid)
        {
          d.result.forEach(function(t,i){
            var ser = chart.get(t.code);
            if(ser === null)
            {  
              chart.addSeries({id:t.code, name: t.code + ' - ' + t.ratio + ' ' + t.name, data: t.rates }, false,false);
              data.nbg.rates_by_currency[t.code] = { code: t.code, name: t.name, label:  t.code + ' - ' + t.ratio + ' ' + t.name,  rates: t.rates } ;
              data.nbg.currencies.push(t.code);
            }     
          });      
          chart.redraw();
        }
      }); 
    }

    if(local_cur.length)
    {
      local_cur.forEach(function(t){
        var ser = chart.get(t);
        if(ser === null)
        {  
          chart.addSeries({id: t, name: data.nbg.rates_by_currency[t].label, data: data.nbg.rates_by_currency[t].rates }, false,false);
        }     
      });
      chart.redraw();
    }
   
    prev_b_chart_currency = c;
  }
  function b_chart(){
    $('#b_chart').highcharts('StockChart', {
      chart:
      {
        backgroundColor: '#f1f2f2'
      },
      colors: [ '#1cbbb4', '#F47C7C', '#4997FF', '#be8ec0', '#8fc743'],
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
          },
          buttons: [{
              type: 'month',
              count: 1,
              text: '1m'
            }, {
              type: 'month',
              count: 3,
              text: '3m'
            }, {
              type: 'month',
              count: 6,
              text: '6m'
            },
            {
              type: 'year',
              count: 1,
              text: '1y'
            }, {
              type: 'all',
              text: 'All'
          }]
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
          // 
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
              marker : {
                enabled : false,
                radius : 3,
                symbol: 'circle'
              }
          }
      },
      tooltip: {
        borderColor: "#cfd4d9",
        headerFormat: '<span class="tooltip-header">{point.key}</span><br/>', 
        pointFormatter: function () {
             return '<div class="tooltip-item"><span style="color:'+this.color+'">'+this.series.name+'</span> <span class="value">'+this.y+'</span>'+ (b_chart_type == 1 ? (' (' + reformat(this.change,2) + '%)') : '') +'</div>'; },
        useHTML: true,
        shadow: false
      },
      legend: {
        enabled: true,
        itemStyle: { "color": "#7b8483", "fontFamily": "oxygen", "fontSize": "15px", "fontWeight": "normal", "lineHeight":"15px" },
        itemHoverStyle: { "color": "#6b7473", "fontFamily": "oxygen", "fontSize": "15px", "fontWeight": "normal", "lineHeight":"15px" },
        useHTML: true
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
      },
      credits: { enabled: false },
      // series: d.rates
    },
    function (chart) {
      setTimeout(function () {
          $('input.highcharts-range-selector', $(chart.container).parent())
              .datepicker({dateFormat: "dd-mm-yy"});
      }, 0);
    });
    b_chart_refresh(true);
  }


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

  function c_chart_refresh(){ // currency, bank
    var chart = $('#rates').highcharts();
    var c = $('.filter-c-currency').select2('val');
    var b = $('.filter-c-bank').select2('val');
     console.log(c,b);
    $.getJSON('/' + I18n.locale + '/rates?currency=' + c + "&bank=" + b.join(','), function (d) {
       console.log(d);
    });
    // if(c != prevCurrency)
    // {
    //   prevCurrency = c;
    //   // while(chart.series.length > 0)
    //   // {
    //   //   chart.series[0].remove(false);
    //   // }
    //   // chart.redraw();
    //   chart.destroy();
    //   if(b === null || b === "") b = ["1"];
    //   else b.unshift("1");
    //   c_chart(c,b);
    // }
    // else
    // {
    //   if(b === null) b = [];
    //   var toDelete = [];
    //   chart.series.forEach(function(d){
    //     if(d.options.id !== "highcharts-navigator-series" && d.options.id !== "b_1" && b.indexOf(d.options.id.replace('b_','').replace('b_buy_','').replace('b_sell_','')) === -1)
    //     {
    //       toDelete.push(d.options.id);
    //     }
    //   });
    //   toDelete.forEach(function(d){
    //     chart.get(d).remove(false);
    //   });


    //   //console.log('rates?currency=' + c + "&bank="+ b.join(','));
    //   if(c !== null && b !== null)
    //   {
    //     $.getJSON('/' + I18n.locale + '/rates?currency=' + c + "&bank="+ b.join(','), function (d) {
    //       d.rates.forEach(function(t,i){
    //         var ser = chart.get(t.id);
    //          if(ser === null)
    //          {  
    //             chart.addSeries(t,false,false);
    //          }     
    //       });      
    //       chart.redraw();
    //     });
    //   }
    // }
  }  
  function c_chart(){
    $('#c_chart').highcharts('StockChart', {
      chart:
      {
        backgroundColor: '#f1f2f2'
      },
      colors: [ '#1cbbb4', '#F47C7C', '#4997FF', '#be8ec0', '#8fc743'],
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
          },
          buttons: [{
              type: 'month',
              count: 1,
              text: '1m'
            }, {
              type: 'month',
              count: 3,
              text: '3m'
            }, {
              type: 'month',
              count: 6,
              text: '6m'
            },
            {
              type: 'year',
              count: 1,
              text: '1y'
            }, {
              type: 'all',
              text: 'All'
          }]
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
          // 
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
              marker : {
                enabled : false,
                radius : 3,
                symbol: 'circle'
              }
          }
      },
      tooltip: {
        borderColor: "#cfd4d9",
        headerFormat: '<span class="tooltip-header">{point.key}</span><br/>', 
        pointFormatter: function () {
             return '<div class="tooltip-item"><span style="color:'+this.color+'">'+this.series.name+'</span> <span class="value">'+this.y+'</span>'+ (b_chart_type == 1 ? (' (' + reformat(this.change,2) + '%)') : '') +'</div>'; },
        useHTML: true,
        shadow: false
      },
      legend: {
        enabled: true,
        itemStyle: { "color": "#7b8483", "fontFamily": "oxygen", "fontSize": "15px", "fontWeight": "normal", "lineHeight":"15px" },
        itemHoverStyle: { "color": "#6b7473", "fontFamily": "oxygen", "fontSize": "15px", "fontWeight": "normal", "lineHeight":"15px" },
        useHTML: true
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
      },
      credits: { enabled: false },
      // series: d.rates
    },
    function (chart) {
      setTimeout(function () {
          $('input.highcharts-range-selector', $(chart.container).parent())
              .datepicker({dateFormat: "dd-mm-yy"});
      }, 0);
    });
    c_chart_refresh(true);
  }  
  
  function paramsRead()
  {
    var hash = window.location.hash.trimLeft('#');
    if(exist(hash))
    {
      var ahash = hash.split("&");
      for(var i = 0; i < ahash.length; ++i)
      {      
        var kv = ahash[i].split("=");
        if(kv.length==2)
        {
          params[kv[0]] = isNumber(kv[1]) ? +kv[1] : kv[1];      
        }
      }
      return true;
    } 
    return false;
  }
  function paramsWrite(k,v)
  {
    var hash = window.location.hash.trimLeft('#');
    var nhash = "";
    var was = false;
    if(exist(hash))
    {
      var ahash = hash.split("&");
      
      for(var i = 0; i < ahash.length; ++i)
      {      
        var kv = ahash[i].split("=");
        if(kv.length==2 && kv[0] == k)
        {
          nhash += '&' + k + '=' + v;
          was = true;
        }
        else
        {
          nhash += '&' + ahash[i];
        }
      }
  
    }
    if(!was) { nhash += '&' + k + '=' + v; }
    
    if(nhash[0]=='&') nhash=nhash.substr(1);
    history.pushState({'hash':nhash},'',window.location.pathname + "#" + nhash);  
  }

  function debounce(func, wait, immediate) {
    var timeout;
    return function() {
      var context = this, args = arguments;
      var later = function() {
        timeout = null;
        if (!immediate) func.apply(context, args);
      };
      var callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow) func.apply(context, args);
    };
  }

  init();
});