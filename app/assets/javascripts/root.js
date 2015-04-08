$(function () {

  var params = { p: 1,
    read: function()
    {
      var hash = window.location.hash.triml('#');
      if(exist(hash))
      {
        var ahash = hash.split("&");
        for(var i = 0; i < ahash.length; ++i)
        {      
          var kv = ahash[i].split("=");
          if(kv.length==2)
          {
            params[kv[0]] = isNumber(kv[1]) ? +kv[1] : kv[1].split(',');      
          }
        }
        return true;
      } 
      return false;
    },
    write: function(pairs) // object of key value pair { c: '', b: ''}
    {
      var hash = window.location.hash.triml('#');
      var hasHash = exist(hash);
      var ahash = hasHash ? hash.split('&').map(function(v,i,a){ return v.split('=') }) : [];

      for(var i = 0; i < ahash.length; ++i)
      {    
        var kv = ahash[i];
        if(!pairs.hasOwnProperty(kv[0]))
        {
          pairs[kv[0]] = kv[1];
        }

      }
      var nhash = this.kv(pairs,'p') + this.kv(pairs,'c') + this.kv(pairs,'b');
      if(nhash[0]=='&') nhash=nhash.substr(1);
      history.pushState({'hash':nhash},'',window.location.pathname + "#" + nhash);  
    },
    clear: function()
    {     
      history.pushState({'hash':''},'',window.location.pathname);  
    },
    resume: function(p)
    {
      this.clear();
      var pars = {p:p};
      if(p == 2) 
      {
        pars['c'] = cur.p2.c.join(',');
      }
      else if(p == 3)
      {
        pars['c'] = cur.p3.c.join(',');
        pars['b'] = cur.p3.b.join(',');
      }
      this.write(pars);
    },
    kv: function(obj,prop)
    {
      if (obj.hasOwnProperty(prop)) {
         if(!exist(obj[prop])) return "";
         return '&' + prop + '=' + obj[prop];
      }
      return "";
    }
  };  
  var cur = { p1: {}, p2: { c: ['USD','EUR','GBP','RUB'], type: 0 }, p3: { c: ['USD'] , b: ['BAGA','TBCB','REPL','LBRT'], type: 0 } }; 
  // p2 type 0 none, 1 percent
  // p3 type 0 both, 1 buy, 2 sell

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
    nbg: { keys: [], rates: {} },
    banks: { keys: [], rates: {} }
  };

  $('.tab[data-id] a').click(function(e){
    var t = $(this).parent();
    $('.tab').removeClass("active");
    t.addClass("active");
    $('.page.active').removeClass("active");
    $('.page[data-tab-id='+t.attr('data-id')+']').addClass("active");
    params.resume(+t.attr('data-id'));
    e.preventDefault();
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
    cur.p2.type = t.attr('data-compare') == 'none' ? 0 : 1;
    chart.yAxis[0].setCompare(t.attr('data-compare'));
  }); 

  $('.c_chart_switch > div').click(function(){
    var t = $(this);
    var p = t.parent();
    p.find('> div').removeClass('active');
    t.addClass('active');
    var chart = $('#c_chart').highcharts();
    var compare = t.attr('data-compare');
    cur.p3.type = compare == 'both' ? 0 : (compare == 'buy' ? 1 : 2);
    c_chart_refresh();
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

  window.onpopstate = function(e){  
    if(e.state !== null) { console.log("backward navigation"); } 
  };

  function init()
  {
    if(params.read())
    {
      if(exist(params.p))
      {        
        if(params.p == 2 && exist(params.c))
        {
          cur.p2.c = params.c;
          $('.filter-b-currency').select2('val', cur.p2.c);
        }
        else if(params.p == 3 && exist(params.c) && exist(params.b))
        { 
          cur.p3.c = params.c;
          cur.p3.b = params.b;
          $('.filter-c-currency').select2('val', cur.p3.c);
          $('.filter-c-bank').select2('val', cur.p3.b);
        }        
        $('.tab[data-id=' + params.p + '] a').trigger('click');
      }
    }
    else $('.tab[data-id=1] a').trigger('click');
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
//    console.log("b_chart_refresh");
    var chart = $('#b_chart').highcharts();
    var c = $('.filter-b-currency').select2('val');

    cur.p2.c.forEach(function(t){
      if(c.indexOf(t)==-1)
      {
        chart.get(t).remove(false);
      }
    });

    cur.p2.c = c;
    if(!first) params.write({c:c});

    var remote_cur = [];
    var local_cur = [];
    c.forEach(function(t){
      if(data.nbg.keys.indexOf(t) == -1)
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
              data.nbg.rates[t.code] = { code: t.code, name: t.name, label:  t.code + ' - ' + t.ratio + ' ' + t.name,  rates: t.rates } ;
              data.nbg.keys.push(t.code);
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
          chart.addSeries({id: t, name: data.nbg.rates[t].label, data: data.nbg.rates[t].rates }, false,false);
        }     
      });
      chart.redraw();
    }
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
             return '<div class="tooltip-item"><span style="color:'+this.color+'">'+this.series.name+'</span> <span class="value">'+this.y+'</span>'+ (cur.p2.type == 1 ? (' (' + reformat(this.change,2) + '%)') : '') +'</div>'; },
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
      credits: { enabled: false }
    },
    function (chart) {
      setTimeout(function () {
          $('input.highcharts-range-selector', $(chart.container).parent())
              .datepicker({dateFormat: "dd-mm-yy"});
      }, 0);
    });
    b_chart_refresh(true);
  }

  function c_chart_refresh(first){ // currency, bank
    //console.log("c_chart_refresh");
    var chart = $('#c_chart').highcharts();

    var c = $('.filter-c-currency').select2('val');
    var b = $('.filter-c-bank').select2('val');

    cur.p3.b.forEach(function(t){
      if(b.indexOf(t)==-1)
      {
        chart.get(t  + '_' + cur.p3.c + '_B').remove(false);
        chart.get(t  + '_' + cur.p3.c + '_S').remove(false);
      }
    });

    cur.p3.c = c;
    cur.p3.b = b;     

    if(!first){ params.write({c:c.join(','), b:b.join(',')}); }

    var remote_cur = [];
    var local_cur = [];
    cur.p3.b.forEach(function(t){
      if(data.banks.keys.indexOf(t + '_' + cur.p3.c + '_B') == -1)
        remote_cur.push(t);
      else local_cur.push(t);
    });    

    if(remote_cur.length)
    {
      $.getJSON('/' + I18n.locale + '/rates?currency=' + c + "&bank=" + remote_cur.join(',')+',BNLN', function (d) {
        if(d.valid)
        {
           d.result.forEach(function(t,i){
            var ser = chart.get(t.id);
            if(ser === null)
            {  
              chart.addSeries({id:t.id, name: t.name, data: t.data }, false,false);
              data.banks.rates[t.id] = { code: t.id, name: t.name, label: t.name, rates: t.data } ;
              data.banks.keys.push(t.id);
            }     
          });      
          chart.redraw();
        }
      }); 
    }
    local_cur.forEach(function(t){
      c_chart_redraw(t + '_' + cur.p3.c);       
    });    
  }  
  function c_chart_redraw(id)
  {
    var chart = $('#c_chart').highcharts();
    var type = cur.p3.type;
    var id_b = id+'_B';
    var id_s = id+'_S';
    var ser_b = chart.get(id_b);
    var ser_s = chart.get(id_s);

    // buy
    if(type == 0 || type == 1)
    {     
      if(ser_b === null)
      {  
        chart.addSeries({ id: id_b, name: data.banks.rates[id_b].name, data: data.banks.rates[id_b].rates },false,false);
      }     
    }
    else
    {
      if(ser_b !== null)
      {  
        ser_b.remove(false);
      }     
    }
    // sell
    if(type == 0 || type == 2)
    {
      if(ser_s === null)
      {  
        chart.addSeries({ id: id_s, name: data.banks.rates[id_s].name, data: data.banks.rates[id_s].rates },false,false);
      }    
    }
    else
    {
      if(ser_s !== null)
      {  
        ser_s.remove(false);
      }     
    } 
    chart.redraw();
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
           // console.log(this.series);
           //  if(cur.p3.type == 0)
           //  {
           //     console.log('gettogether');
           //  }
            return '<div class="tooltip-item"><span style="color:'+this.color+'">'+this.series.name+'</span> <span class="value">'+this.y+'</span>'+ (cur.p2.type == 1 ? (' (' + reformat(this.change,2) + '%)') : '') +'</div>'; },
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

