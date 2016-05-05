/*global window $ Highcharts gon I18n exist isNumber */
/*eslint camelcase: 0, no-underscore-dangle: 0, no-unused-vars: 0*/
$(function () {
  Highcharts.getOptions().exporting.buttons.contextButton.menuItems.push({
    text: gon.downloadCSV,
    onclick: function (e) {
      var t = this;
      var id = t.userOptions.chart_id;
      var href = "";
      if(id == 1)
      {
        href = "/" + I18n.locale + "/data_download?type=calculator&currency=USD&amount="+data.worth+"&direction="+data.dir+"&start_date=" + new Date(data.date_from).format("isoDate")+ "&end_date=" + new Date(data.date_to).format("isoDate");
      }
      else if(id == 2)
      {
        href = "/" + I18n.locale + "/data_download?type=national_bank&currency=" + cur.p2.c.join(",");
      }
      else if(id == 3)
      {
        href = "/" + I18n.locale + "/data_download?type=commercial_banks&currency=" + cur.p3.c + "&bank=" + cur.p3.b.join(",");
      }
      if(href!="") window.location.href = href;
    }
  });
  if(document.documentElement.lang == "ka")
  {
    Highcharts.setOptions({
      lang: {
        months: ["იანვარი", "თებერვალი", "მარტი", "აპრილი", "მაისი", "ივნისი", "ივლისი", "აგვისტო", "სექტემბერი", "ოქტომბერი", "ნოემბერი", "დეკემბერი"],
        weekdays: ["კვირა", "ორშაბათი", "სამშაბათი", "ოთხშაბათი", "ხუთშაბათი", "პარასკევი", "შაბათი"],
        shortMonths: [ "იანვ", "თებ", "მარ", "აპრ", "მაისი", "ივნ", "ივლ", "აგვ", "სექტ", "ოქტ", "ნოემ", "დეკ"],
        rangeSelectorFrom: "თარიღი",
        rangeSelectorTo: "-",
        rangeSelectorZoom: "ზუმი",
        downloadPNG: gon.highcharts_downloadPNG,
        downloadJPEG: gon.highcharts_downloadJPEG,
        downloadPDF: gon.highcharts_downloadPDF,
        downloadSVG: gon.highcharts_downloadSVG,
        printChart: gon.highcharts_printChart,
        contextButtonTitle: gon.highcharts_contextButtonTitle
      }
    });
  }
  else
  {
    Highcharts.setOptions({
      lang: {
        rangeSelectorFrom: "Date",
        rangeSelectorTo: "-",
        downloadPNG: gon.highcharts_downloadPNG,
        downloadJPEG: gon.highcharts_downloadJPEG,
        downloadPDF: gon.highcharts_downloadPDF,
        downloadSVG: gon.highcharts_downloadSVG,
        printChart: gon.highcharts_printChart,
        contextButtonTitle: gon.highcharts_contextButtonTitle
      }
    });
  }
  var custom_buttons = [{ type: "month", count: 1, text: gon.m1 },
                          { type: "month", count: 3, text: gon.m3 },
                          { type: "month", count: 6, text: gon.m6 },
                          { type: "year", count: 1, text: gon.y1 },
                          { type: "all", text: gon.all }];
  var custom_buttons_theme = {
    fill: "#fff",
    stroke: "#c0c7cd",
    "stroke-width": 1,
    style: { color: "#7b8483" },
    states: {
      hover: {
        fill: "#ffc539",
        stroke: "#ffc539",
        style: { color: "#4d4d4d" }
      },
      select: {
        fill: "#ffc539",
        stroke: "#ffc539",
        style: { color: "#4d4d4d" }
      }
    }
  };
  gon.currency_to_bank = JSON.parse(gon.currency_to_bank);
  var nbg = "BNLN";
  var nav_id = "highcharts-navigator-series";
  var params = { p: "national_bank",
    read: function ()
    {
      var hash = window.location.hash.triml("#");
      if(exist(hash))
      {
        var ahash = hash.split("&");
        for(var i = 0; i < ahash.length; ++i)
        {
          var kv = ahash[i].split("=");
          if(kv.length==2)
          {
            params[kv[0]] = isNumber(kv[1]) ? +kv[1] : (kv[1]!="" ? kv[1].split(",") : []);
          }
        }
        return true;
      }
      return false;
    },
    write: function (pairs) // object of key value pair { c: "", b: ""}
    {
      var hash = window.location.hash.triml("#");
      var hasHash = exist(hash);
      var ahash = hasHash ? hash.split("&").map(function (v, i, a){ return v.split("="); }) : [];

      for(var i = 0; i < ahash.length; ++i)
      {
        var kv = ahash[i];
        if(!pairs.hasOwnProperty(kv[0]))
        {
          pairs[kv[0]] = kv[1];
        }

      }
      var nhash = this.kv(pairs, "p") + this.kv(pairs, "c") + this.kv(pairs, "b");
      if(nhash[0]=="&") nhash=nhash.substr(1);
      history.pushState({"hash":nhash}, "", window.location.pathname + "#" + nhash);
      var lang_link = $("#lang-link");
      lang_link.attr("href", lang_link.attr("url") + "#" + nhash);
    },
    clear: function ()
    {
      history.pushState({"hash":""}, "", window.location.pathname);
    },
    resume: function (p)
    {
      this.clear();
      var pars = {p:p};

      if(p == "national_bank")
      {
        pars["c"] = cur.p2.c.join(",");
      }
      else if(p == "commercial_banks")
      {
        pars["c"] = cur.p3.c;
        pars["b"] = cur.p3.b.join(",");
      }
      this.write(pars);
    },
    kv: function (obj, prop)
    {
      if (obj.hasOwnProperty(prop)) {
        if(!exist(obj[prop])) return "";
        return "&" + prop + "=" + obj[prop];
      }
      return "";
    }
  };
  var cur = { p1: {}, p2: { c: ["USD", "EUR", "GBP", "RUB"], type: 0 }, p3: { c: ["USD"], b: ["BAGA", "TBCB", "REPL", "LBRT"], type: 0 } };
  // p2 type 0 none, 1 percent
  // p3 type 0 both, 1 buy, 2 sell

  var from = $(".calculator .from[data-type=datepicker]");
  var to = $(".calculator .to[data-type=datepicker]");
  var worth = $("#worth").on("keyup", function () { debounce(calculate(), 500); });
  var worth_then = $("#worth_then .value");
  var worth_now = $("#worth_now .value");
  var rate_then = $("#rate_then .value");
  var rate_now = $("#rate_now .value");
  var worth_diff = $("#worth_diff .value");
  var info_text = $("#info_text");

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


  $(".tabbox > .toggle > div[data-ref]").click(function (e){
    var t = $(this), ref = t.attr("data-ref"), toggle = t.parent(), content = toggle.parent().find(".content"), c = content.find("> div[data-ref='"+ref+"']");
    toggle.find("> div[data-ref]").removeClass("active");
    t.addClass("active");
    content.find("> div[data-ref]").removeClass("active");
    c.addClass("active");
    // $(".page.active").removeClass("active");
    // var ptmp = $(".page[data-tab-id="+t.attr("data-id")+"]").addClass("active");
    // params.resume(t.attr("data-id"));
    // e.preventDefault();
    // if(e.originalEvent != undefined && $(".menu-toggle").css("display") != "none"){ // was programmatically called or not
    //   $(".tabs").toggle();
    // }
    // document.title = this.text + gon.app_name;
    // $("meta[property='og:title']").attr("content", document.title);
    // var descr = ptmp.find(".intro").text();
    // $("meta[name=description]").attr("content", descr);
    // $("meta[property='og:description']").attr("content", descr);
  });
  $("select#convertor-currency").select2({ maximumSelectionSize: 5,
    formatResult: function (d){
      return "<div class='flag'><img src='/assets/png/flags/"+d.id+".png'/></div><div class='abbr'>"+d.id+"</div><div class='name'>"+d.text+"</div>";
    },
    formatSelection: function (d)
    {
      return "<div title='"+d.text+"'>"+d.id+"</div>";
    },
    matcher: function (term, text, opt) { return text.toUpperCase().indexOf(term.toUpperCase())>=0 || opt.val().toUpperCase().indexOf(term.toUpperCase())>=0; }
  });

  var convertor = $(".page3 .content [data-ref='convertor'] > .table");
    convertor.find("> bank").remove();
  gon.banks.forEach(function(bnk){
     console.log(bnk);
    var html = "<div class='bank row' data-bank-id='"+bnk[0]+"'><div class='column'><div class='key'><img src='/assets/png/banks/" + bnk[3]["data-image"]+".jpg'><span>"+bnk[1]+"</span></div></div><div class='column'><div class='value'><span>2.238</span></div></div><div class='column'><div class='rate'>2.525</div></div></div>";
    //return "<div class='logo vtop'><img src='"+d.image+".jpg'/></div><div class='name vtop'>"+d.text+"</div>"; // <div class='abbr'>"+d.id+"</div>
    convertor.append(html);
  });
  $(".tab[data-id] a").click(function (e){
    var t = $(this).parent();
    $(".tab").removeClass("active");
    t.addClass("active");
    $(".page.active").removeClass("active");
    var ptmp = $(".page[data-tab-id="+t.attr("data-id")+"]").addClass("active");
    params.resume(t.attr("data-id"));
    e.preventDefault();
    if(e.originalEvent != undefined && $(".menu-toggle").css("display") != "none"){ // was programmatically called or not
      $(".tabs").toggle();
    }
    document.title = this.text + gon.app_name;
    $("meta[property='og:title']").attr("content", document.title);
    var descr = ptmp.find(".intro").text();
    $("meta[name=description]").attr("content", descr);
    $("meta[property='og:description']").attr("content", descr);
  });

  $("select.filter-b-currency").select2({ maximumSelectionSize: 5,
    // width:380,
    formatResult: function (d){
      return "<div class='flag'><img src='/assets/png/flags/"+d.id+".png'/></div><div class='abbr'>"+d.id+"</div><div class='name'>"+d.text+"</div>";
    },
    formatSelection: function (d)
    {
      return "<div title='"+d.text+"'>"+d.id+"</div>";
    },
    matcher: function (term, text, opt) { return text.toUpperCase().indexOf(term.toUpperCase())>=0 || opt.val().toUpperCase().indexOf(term.toUpperCase())>=0; }
  });
  $("select.filter-c-currency").select2({ maximumSelectionSize: 1,
    allowClear:false,
    /*width:380,*/
    formatResult: function (d){
      return "<div class='flag'><img src='/assets/png/flags/"+d.id+".png'/></div><div class='abbr'>"+d.id+"</div><div class='name'>"+d.text+"</div>";
    },
    formatSelection: function (d)
    {
      return "<div title='"+d.text+"'>"+d.id+"</div>";
    },
    matcher: function (term, text, opt) { return text.toUpperCase().indexOf(term.toUpperCase())>=0 || opt.val().toUpperCase().indexOf(term.toUpperCase())>=0; }
  });


  $("#worth").focusout(function (){
    var t = $(this),
      v = +t.val().replace(/,/g, "");
    t.val(v.toLocaleString());
  });

  $(".currency-switch > div").click(function (){
      var t = $(this);
      if(t.hasClass("active")) return;
      var p = t.parent();
      p.find("> div").removeClass("active");
      t.addClass("active");
      $(".calculator .symbol,.calculator .symbol2").toggleClass("gel usd");


      data.dir = t.attr("data-option") == "GEL" ? 1 : 0;
      $(".calculator .symbol, .calculator .symbol2").attr("title", data.dir == 1 ? gon.usd : gon.gel );
      $(".hsw .text").find(".from-value").text(data.dir == 1 ? "GEL" : "USD");
      $(".hsw .text").find(".to-value").text(data.dir == 1 ? "USD" : "GEL");
      calculate(false);
    });

  $(".b_chart_switch > div").click(function (){
    var t = $(this);
    var p = t.parent();
    p.find("> div").removeClass("active");
    t.addClass("active");
    var chart = $("#b_chart").highcharts(),
      compare = t.attr("data-compare");

    cur.p2.type = compare == "none" ? 0 : 1;

    // for this code to work we need to paste
    // if(typeof d["jsCompareValue"]!==undefined) {d.plotOptions.series.compare = d["jsCompareValue"];}
    // to highcharts export module in  getSVG before creating new Highcharts object
    chart.options["jsCompareValue"] = compare;

    chart.yAxis[0].setCompare(compare);
    chart.options.plotOptions.series.compare = compare;
    chart.yAxis[0].update({ title:{ text: (cur.p2.type == 0 ? gon.gel : "%"),
      rotation: 0,
            margin: cur.p2.type == 0 ? 15 : 25,
            style:
            {
              fontFamily: "glober-sb",
              fontSize: "17px",
              color:"#7b8483"
            },
            x: cur.p2.type == 0 ? -15 : 0
  } });
  });

  $(".c_chart_switch > div").click(function (){
    var t = $(this);
    var p = t.parent();
    p.find("> div").removeClass("active");
    t.addClass("active");
    var chart = $("#c_chart").highcharts();
    var compare = t.attr("data-compare");
    var b = compare == "both";
    chart.userOptions.magic = b;
    chart.legend.options.magic = b;
    cur.p3.type = b ? 0 : (compare == "buy" ? 1 : 2);
    c_chart_refresh(false, true);
  });

  $.datepicker.setDefaults($.datepicker.regional[I18n.locale]);
  $(".calculator .from[data-type=datepicker]").datepicker({
    dateFormat: "d M, yy",
    defaultDate: "-3m",
    changeMonth: true,
    changeYear: true,
    maxDate: "d",
    gotoCurrent: true,
    onClose: function ( v ) {
      $(".calculator .to[data-type=datepicker]").datepicker( "option", "minDate", v );
      this._visible = false;
    },
    onSelect: function (v, o) {
      if($(this).datepicker("getDate").getTime() != data.date_from)
      {
        calculate(true);
      }
    }
  }).datepicker("setDate", "-3m")
  .on("click", function (e){
    var t = $(this);
    var b = (this._visible !== undefined && this._visible === true);
    t.datepicker(b ? "hide" : "show");
    this._visible = !b;
    e.preventDefault();
  });

  $(".calculator .to[data-type=datepicker]").datepicker({
    dateFormat: "d M, yy",
    defaultDate: "d",
    changeMonth: true,
    changeYear: true,
    maxDate: "d",
    gotoCurrent: true,
    onClose: function (v) {
      $(".calculator .from[data-type=datepicker]").datepicker( "option", "maxDate", v );
      this._visible = false;
    },
    onSelect: function () {
      if($(this).datepicker("getDate").getTime() != data.date_to)
      {
        calculate(true);
      }
    }
  }).datepicker("setDate", "d")
  .on("click", function (e){
    var t = $(this);
    var b = (this._visible !== undefined && this._visible === true);
    t.datepicker(b ? "hide" : "show");
    this._visible = !b;
    e.preventDefault();
  });


  $(".filter-c-currency").on("change", function (){

    var c = $(this).select2("val");
    var b = $("input.filter-c-bank").select2("val");
    var e = gon.currency_to_bank[c];
    var data = [];
    if(c.length > 0)
    {
      b.forEach(function (d, i){
        gon.banks.forEach(function (dd, ii){
          if(d == dd[2] && e.indexOf(dd[0]) != -1)
          {
            data.push(dd[2]);
          }
        });
      });
    }
    $("input.filter-c-bank").select2("val", data);
    c_chart_refresh();
  });
  $(".filter-b-currency").on("change", function (){ b_chart_refresh(); });

  window.onpopstate = function (e){
    if(e.state !== null) {/* console.log("backward navigation");*/ }
  };

  function init () {
    if(params.read())
    {
      if(exist(params.p))
      {
        if(params.p == "national_bank" && exist(params.c))
        {
          cur.p2.c = params.c;
          $(".filter-b-currency").select2("val", cur.p2.c);
        }
        else if(params.p == "commercial_banks" && exist(params.c) && exist(params.b))
        {
          cur.p3.c = params.c;
          cur.p3.b = params.b;
          $(".filter-c-currency").select2("val", cur.p3.c);
          $(".filter-c-bank").val(cur.p3.b);
        }
        $(".tab[data-id=" + params.p + "] a").trigger("click");
      }
    }
    else $(".tab[data-id=commercial_banks] a").trigger("click");
    prepare();
    calculate(true);
    b_chart();
    c_chart();
  }
  function prepare ()
  {
    c_filter_bank();
  }
  function calculate (remote)
  {
    $("#a_chart").addClass("loader");
    data.worth = getWorth();
    if(data.worth > 0)
    {
      if(remote)
      {
        data.date_from = from.datepicker("getDate").getTime();
        data.date_to = to.datepicker("getDate").getTime();

        var cur_to = $("#currency_switch > div:not(.active)").attr("data-option");

        $.getJSON("/" + I18n.locale + "/api/v1/nbg_rates?currency=USD&start_date=" + data.date_from+ "&end_date=" + data.date_to, function (d) {
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
      worth_then.text("");
      worth_now.text("");
      rate_now.text("");
      rate_then.text("");
      worth_diff.text("");
    }
  }


  function output (){
    var rate_from = data.rate_from_init;
    var rate_to = data.rate_to_init;
    var text = $("<div>" + gon.info_usd + "</div>");
    if(data.dir == 1)
    {
      rate_from = (1/rate_from).toFixed(4);
      rate_to = (1/rate_to).toFixed(4);
      text = $("<div>" + gon.info_gel + "</div>");
    }
    var old_worth = data.worth * rate_from;
    var new_worth = data.worth * rate_to;
    rate_then.text(reformat(rate_from, 4));
    rate_now.text(reformat(rate_to, 4));
    worth_then.text(reformat(old_worth));
    worth_now.text(reformat(new_worth));
    var diff = old_worth - new_worth;
    var inc_dec = "";

    inc_dec = new_worth > old_worth ? gon.increased : gon.decreased;
    text.find(".up").text(inc_dec);
    $(".diff .label .up").text(inc_dec);

    var info_value = data.dir == 1 ?
        Math.abs(5200000000 - 5200000000 * data.rate_from_init/ data.rate_to_init)
      : Math.abs(5200000000*data.rate_from_init - 5200000000*data.rate_to_init);

    text.find(".value").text(reformat(info_value, 0));
    info_text.html(text);

    worth_diff.text(reformat(Math.abs(diff)));

    a_chart();
  }
  function reformat (n, s){
    s = typeof s === "number" ? s : 2;
    n = +n;
    var x = n.toFixed(s).split("."),
      x1 = x[0],
      rgx = /(\d+)(\d{3})/;

    while (rgx.test(x1)) {
      x1 = x1.replace(rgx, "$1" + "," + "$2");
    }
    return x1 + (x.length > 1 ? "." + x[1] : "");//(+n.toFixed(s)).toLocaleString();
  }
  function getWorth (){
    var t = parseFloat(worth.val().replace(/,|\s/g, ""));
    return isNaN(t) ? 0 : t;
  }

  function a_chart (){

    var chart = $("#a_chart").highcharts();

    var worths = [];
    data.rates.forEach(function (d){
      var r = (data.dir == 0 ? d[1] : +(1/d[1]).toFixed(4)).toFixed(2);
      worths.push({ x: d[0], y: (r * data.worth), rate:r, dir: (data.dir==0 ? "gel" : "usd") });
    });

    if(typeof chart === "undefined")
    {
      $("#a_chart").highcharts({
        chart_id:1,
        chart:
        {
          backgroundColor: "#f1f2f2",
          height: 340
        },
        title: {
          text: gon.a_chart_title,
          align: "left",
          margin: 50,
          useHTML: true,
          style:
          {
            fontFamily: "glober-sb",
            fontSize: "24px",
            color:"#7b8483",
            borderBottom: "1px solid #7b8483",
            paddingBottom: "3px"
          },
          x: 30,
          y: 30
        },
        xAxis: {
          labels: {
            style: {
              fontFamily: "glober-sb",
              fontSize: "13px",
              color:"#7b8483"
            }
          },
          type: "datetime"
        },
        yAxis: {
          gridLineColor: "#ffffff",
          gridLineWidth: 2,
          title: {
            text: "USD",
            rotation: 0,
            margin:20,
            style:
            {
              fontFamily: "glober-sb",
              fontSize: "17px",
              color:"#7b8483"
            },
            x:-10
          },
          labels: {
            style: {
              paddingBottom: "20px",
              color: "#f6ba29",
              fontFamily: "glober-sb",
              fontSize: "16px"
            }
          }
        },
        plotOptions: {
          series: {
            marker : {
              enabled : false,
              radius : 3,
              symbol: "circle"
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
          headerFormat: "<span class='tooltip-header'>{point.key}</span><br/>",
          pointFormatter: function (d) {
            return "<div class='tooltip-content'><span>"+gon.rate+":</span> "+reformat(this.rate, 3)+" <span class='symbol "+this.dir+"'></span><br/><span>"+gon.monetary_value+":</span> "+reformat(this.y, 3)+" <span class='symbol "+this.dir+"'></span></div>";
          },
          useHTML: true
        },
        series: [{
          id:"a1", data: worths, color: "#f6ba29"
        }]
      });
    }
    else
    {
      chart.yAxis[0].update({
        title:{
          text: (data.dir == 1 ? "USD" : gon.gel)
        }
      });

      chart.get("a1").remove(false);
      chart.addSeries({ id:"a1", data: worths, color: "#f6ba29",
            marker : {
              enabled : false,
              radius : 3,
              symbol: "circle"
            }
          }, false, false);
      chart.redraw();
    }
    $("#a_chart").removeClass("loader");
  }
  var b_chart_colors = ["#1cbbb4", "#F47C7C", "#4997FF", "#be8ec0", "#8fc743"];
  function b_chart_refresh (first){
    var chart = $("#b_chart").addClass("loader").highcharts();
    var c = $(".filter-b-currency").select2("val");
    cur.p2.c.forEach(function (t){
      if(c.indexOf(t)==-1)
      {
        var ser = chart.get(t);
        b_chart_colors.unshift(ser.color);
        ser.remove(false);
      }
    });

    if(!first && chart.series.length == 1)
    {
      var nav = chart.get(nav_id);
      nav.setData([]);
    }

    cur.p2.c = c;
    if(!first) params.write({c:c});

    var remote_cur = [];
    var local_cur = [];
    c.forEach(function (t){
      if(data.nbg.keys.indexOf(t) == -1)
        remote_cur.push(t);
      else local_cur.push(t);
    });
    if(remote_cur.length)
    {
      $.getJSON("/" + I18n.locale + "/api/v1/nbg_rates?currency=" + remote_cur.join(","), function (d) {
        if(d.valid)
        {
          d.result.forEach(function (t, i){
            var ser = chart.get(t.code);
            if(ser === null)
            {
              if(!first && chart.series.length == 1)
              {
                var nav = chart.get(nav_id);
                nav.setData(t.rates);
              }
              chart.addSeries({id:t.code, name: t.code + " - " + t.ratio + " " + t.name, data: t.rates, color: b_chart_colors.shift() }, false, false);
              data.nbg.rates[t.code] = { code: t.code, name: t.name, label:  t.code + " - " + t.ratio + " " + t.name, rates: t.rates } ;
              data.nbg.keys.push(t.code);
            }
          });
          chart.redraw();
          $("#b_chart").removeClass("loader");
        }
      });
    }

    if(local_cur.length)
    {
      local_cur.forEach(function (t){
        var ser = chart.get(t);
        if(ser === null)
        {
          if(chart.series.length == 1)
          {
            var nav = chart.get(nav_id);
            nav.setData(data.nbg.rates[t].rates);
          }
          chart.addSeries({id: t, name: data.nbg.rates[t].label, data: data.nbg.rates[t].rates, color: b_chart_colors.shift() }, false, false);
        }
      });
      chart.redraw();
    }
    if(!remote_cur.length) {
      $("#b_chart").removeClass("loader");
    }
  }
  function b_chart (){
    $("#b_chart").highcharts("StockChart", {
      chart_id:2,
      chart:
      {
        backgroundColor: "#f1f2f2"
      },
      colors: [ "#1cbbb4", "#F47C7C", "#4997FF", "#be8ec0", "#8fc743"],
      rangeSelector: {
        selected: 0,
        inputDateFormat: "%d-%b-%Y",
        inputEditDateFormat: "%d-%b-%Y",
        inputBoxWidth: 120,
        inputBoxHeight: 20,
        inputStyle: { cursor: "pointer" },
        inputDateParser:function (v)
        {
          v = $.datepicker.parseDate( "dd-M-yy", v);
          return Date.UTC(v.getFullYear(), v.getMonth(), v.getDate(), 0, 0, 0, 0);
        },
        buttons: custom_buttons,
        buttonTheme: custom_buttons_theme
      },
      xAxis: {
        tickColor: "#d7e0e7",
        lineColor: "#d7e0e7",
        labels: {
          style: {
            fontFamily: "glober-sb",
            fontSize: "13px",
            color:"#7b8483"
          }
        }
      },
      yAxis: {
        title: {
          enabled: true,
          text: gon.gel,
          rotation: 0,
          margin:15,
          style:
          {
            fontFamily: "glober-sb",
            fontSize: "17px",
            color:"#7b8483"
          },
          x: -15
        },
        opposite: false,
        gridLineColor: "#ffffff",
        gridLineWidth: 2,
        plotLines: [{
          value: 0,
          width: 2,
          color: "silver"
        }],
        //
        labels:
        {
          style: {
            color: "#f6ba29",
            fontFamily: "glober-sb",
            fontSize: "16px"
          }
        }
      },
      plotOptions: {
        series: {
          marker : {
            enabled : false,
            radius : 3,
            symbol: "circle"
          }
        }
      },
      tooltip: {
        borderColor: "#cfd4d9",
        headerFormat: "<span class='tooltip-header'>{point.key}</span><br/>",
        pointFormatter: function () {
          return "<div class='tooltip-item'><span style='color:"+this.color+"'>"+this.series.name+"</span> <span class='value'>"+reformat(this.y, 3)+"</span>"+ (cur.p2.type == 1 ? (" (" + reformat(this.change, 2) + "%)") : "") + "</div>"; },
        useHTML: true,
        shadow: false
      },
      legend: {
        enabled: true,
        itemStyle: { "color": "#7b8483", "fontFamily": "oxygen", "fontSize": "15px", "fontWeight": "normal", "lineHeight":"15px" },
        itemHoverStyle: { "color": "#6b7473", "fontFamily": "oxygen", "fontSize": "15px", "fontWeight": "normal", "lineHeight":"15px" },
        useHTML: true
      },
      credits: { enabled: false }
    },
    function (chart) {
      setTimeout(function () {
        $("input.highcharts-range-selector", $(chart.container).parent())
          .datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true,
                maxDate: "d",
                gotoCurrent: true,
                beforeShow: function (t) {
                  $(this).datepicker("setDate", new Date(t["HCTime"]));
                  $(chart.container).find(".highcharts-input-group > g:nth-of-type("+(this.name == "min" ? 2 : 4)+") text").attr("visibility", "hidden");
                },
                onClose: function () {
                  $(chart.container).find(".highcharts-input-group > g:nth-of-type("+(this.name == "min" ? 2 : 4)+") text").attr("visibility", "visible");
                }
              }).attr("readonly", "readonly");
      }, 0);
    });
    b_chart_refresh(true);
  }

  function c_chart_refresh (first, partial){ // currency, bank
    var chart = $("#c_chart").addClass("loader").highcharts();

    var c = $(".filter-c-currency").select2("val");
    var b = $(".filter-c-bank").select2("val");

    cur.p3.c = c;
    cur.p3.b = b;

    var toDelete = [];
    chart.series.forEach(function (t){
      if(t.userOptions.id != nav_id)
      {
        if(t.userOptions.code==nbg)
        {
          if(!partial) toDelete.push(t.userOptions.id);
        }
        else toDelete.push(t.userOptions.id);
      }
    });
    toDelete.forEach(function (t){
      var s = chart.get(t);
      s.remove(false);
    });
    if(!first){ params.write({c:c, b:b.join(",")}); }

    var remote_cur = [];
    var local_cur = [];
    cur.p3.b.forEach(function (t){
      if(data.banks.keys.indexOf(t + "_" + cur.p3.c + "_B") == -1)
        remote_cur.push(t);
      else local_cur.push(t);
    });

    if(!partial)
    {
      if(data.banks.keys.indexOf(nbg+"_" + cur.p3.c) == -1)
        remote_cur.push(nbg);
      else
      {
        var tmp = data.banks.rates[nbg+"_" + cur.p3.c];
        chart.addSeries({id: nbg, code: tmp.code, color:tmp.color, data: tmp.data, name: tmp.name, legendIndex : tmp.legendIndex }, false, false);
        var nav = chart.get(nav_id);
        nav.setData(data.banks.rates[nbg+"_" + cur.p3.c].data);

      }
    }
    if(remote_cur.length)
    {
      $.getJSON("/" + I18n.locale + "/api/v1/commercial_bank_rates?currency=" + c + "&bank=" + remote_cur.join(","), function (d) {
        // console.log(d);
        if(d.valid)
        {
          d.result.forEach(function (t, i){
            var ser = chart.get(t.id);
            if(ser === null)
            {
              chart.addSeries(t, false, false);
              data.banks.rates[t.id] = t;
              data.banks.keys.push(t.id);
            }
          });
          if(!first && !partial)
          {
            var nav = chart.get(nav_id);
            nav.setData(data.banks.rates[nbg+"_" + cur.p3.c].data);

          }
          chart.redraw();
          $("#c_chart").removeClass("loader");
        }
      });
    }
    local_cur.forEach(function (t){
      c_chart_redraw(t + "_" + cur.p3.c);
    });

    chart.redraw();
    if(!remote_cur.length) {
      $("#c_chart").removeClass("loader");
    }
  }
  function c_chart_redraw (id)
  {
    var chart = $("#c_chart").highcharts(),
      type = cur.p3.type,
      ids = [id+"_B", id+"_S"],
      types = [1, 2];

    ids.forEach(function (d, i){
      if(type == 0 || type == types[i]) {
        delete data.banks.rates[d].events; // fix for: Cannot read property 'getExtremes' of undefined
        // for some reason highchart adds events that raise error on redraw
        data.banks.rates[d]["id"] = d;
        chart.addSeries(data.banks.rates[d], false, false);
      }
    });
  }
  function c_chart () {
    var output = {};
    $("#c_chart").highcharts("StockChart", {
      chart_id: 3,
      magic: true,
      chart:
      {
        backgroundColor: "#f1f2f2"
      },
      colors: [ "#1cbbb4", "#F47C7C", "#4997FF", "#be8ec0", "#8fc743"],
      rangeSelector: {
        selected: 0,
        inputDateFormat: "%d-%b-%Y",
        inputEditDateFormat: "%d-%b-%Y",
        inputBoxWidth: 120,
        inputBoxHeight: 20,
        inputStyle: { cursor: "pointer" },
        inputDateParser:function (v)
        {
          v = $.datepicker.parseDate( "dd-M-yy", v);
          return Date.UTC(v.getFullYear(), v.getMonth(), v.getDate(), 0, 0, 0, 0);
        },
        buttons: custom_buttons,
        buttonTheme: custom_buttons_theme
      },
      xAxis: {
        tickColor: "#d7e0e7",
        lineColor: "#d7e0e7",
        labels: {
          style: {
            fontFamily: "glober-sb",
            fontSize: "13px",
            color:"#7b8483"
          }
        }
      },
      yAxis: {
        title: {
          enabled: true,
          text: gon.gel,
          rotation: 0,
          margin:15,
          style:
          {
            fontFamily: "glober-sb",
            fontSize: "17px",
            color:"#7b8483"
          },
          x: -15
        },
        opposite: false,
        gridLineColor: "#ffffff",
        gridLineWidth: 2,
        plotLines: [{
          value: 0,
          width: 2,
          color: "silver"
        }],
        //
        labels:
        {
          style: {
            color: "#f6ba29",
            fontFamily: "glober-sb",
            fontSize: "16px"
          }
        }
      },
      plotOptions: {
        series: {
          marker : {
            enabled : false,
            radius : 3,
            symbol: "circle"
          }
        }
      },
      tooltip: {
        borderColor: "#cfd4d9",
        headerFormat: "<span class='tooltip-header'>{point.key}</span><br/>",

        pointFormatter: function (f, len, ind) {
          // for len and ind to appear we need to overwrite highstock.js function
          // bodyFormatter:function(a){var alength = a.length;return xa(a,function(a){var aindex=arguments[1];var c=a.series.tooltipOptions;return(c.pointFormatter||a.point.tooltipFormatter).call(a.point,c.pointFormat,alength,aindex)})}
          var t = this,
            s = t.series;

          if(ind == 0)
          {
            output = {};
          }

          if (s.userOptions.code == nbg)
          {
            output[s.userOptions.code] = { name: s.userOptions.name, rate: t.y, color: t.color };
          }
          else
          {

            if(output.hasOwnProperty(s.userOptions.code))
            {
              output[s.userOptions.code][s.userOptions.rate_type] = t.y;
            }
            else
            {
              output[s.userOptions.code] = { name: s.userOptions.name };
              output[s.userOptions.code][s.userOptions.rate_type] = t.y;
            }
            output[s.userOptions.code]["color"] = t.color;
          }
          if(len==ind+1)
          {
            var item = output[nbg],
              type = cur.p3.type,
              rat = gon.currencies.filter(function(r){ return cur.p3.c === r[0]; }),
              ret = rat.length ? ("<span class='tooltip-header'>1 " + gon.gel + " : " + rat[0][2] + " " + rat[0][0] + "</span><br/>") : "";
              ret += "<div class='tooltip-item nbg'><span class='l' style='color:"+item.color+";'>"+item.name + "</span><span class='r'  style='color:"+item.color+";'>" + reformat(item.rate, 3) + "</span></div>";
            if(len > 1)
            {
              ret += "<div class='tooltip-item-header'><span></span>";
              if(type == 0 || type == 1) ret +="<span>" + gon.buy + "<br><svg width='20px' height='4px' xmlns='http://www.w3.org/2000/svg'><g zIndex='1' ><path fill='none' d='M 0 2 L 20 2' stroke-dasharray='2,2' stroke='#7b8483' stroke-width='2'></path></g></svg></span>";
              if(type == 0 || type == 2) ret +="<span>" + gon.sell + "<br><svg width='20px' height='4px' xmlns='http://www.w3.org/2000/svg'><g zIndex='1' ><path fill='none' d='M 0 2 L 20 2' stroke-dasharray='6,2' stroke='#7b8483' stroke-width='2'></path></g></svg></span>";
              ret += "</div>";
            }

            for (var key in output) {
              if (output.hasOwnProperty(key) && key != nbg) {
                item = output[key];
                ret += "<div class='tooltip-item'><span class='l' style='color:"+item.color+";'>"+item.name + "</span>";

                if(type == 0 || type == 1) ret +="<span class='b' style='color:"+item.color+";'>" + reformat(item.buy, 3) + "</span>";
                if(type == 0 || type == 2) ret +="<span class='s' style='color:"+item.color+";'>" + reformat(item.sell, 3) + "</span>";
                ret += "</div>";
              }
            }
            return ret;
          }
          return "";
        },
        useHTML: true,
        shadow: false
      },
      legend: {
        enabled: true,
        magic: true,
        magic_noclick: true,
        align:"left",
        itemStyle: { "color": "#7b8483", "fontFamily": "oxygen", "fontSize": "15px", "fontWeight": "normal", "lineHeight":"15px", "cursor":"default" },
        itemHoverStyle: { "color": "#6b7473", "fontFamily": "oxygen", "fontSize": "15px", "fontWeight": "normal", "lineHeight":"15px", "cursor":"default" },
        labelFormatter:function ()
        {
          if(this.chart.userOptions.magic === true) {
            if(this.userOptions.code == nbg) {
              return this.name;
            }
            else {
              return this.userOptions.rate_type == "buy" ? this.name : "";
            }
          }
          else return this.name;
        }
      },
      credits: { enabled: false }
    },
    function (chart) {
      setTimeout(function () {
        $("input.highcharts-range-selector", $(chart.container).parent())
          .datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true,
                maxDate: "d",
                gotoCurrent: true,
                beforeShow: function (t) {
                  $(this).datepicker("setDate", new Date(t["HCTime"]));
                  $(chart.container).find(".highcharts-input-group > g:nth-of-type("+(this.name == "min" ? 2 : 4)+") text").attr("visibility", "hidden");
                },
                onClose: function () {
                  $(chart.container).find(".highcharts-input-group > g:nth-of-type("+(this.name == "min" ? 2 : 4)+") text").attr("visibility", "visible");
                }
              }).attr("readonly", "readonly");
      }, 0);
      // $("input.highcharts-range-selector", $(chart.container).parent()).on("blur", function() {
      //    console.log("input");
      // });
    });
    c_chart_refresh(true);
  }
  function c_filter_bank (){
    $("input.filter-c-bank").select2({
      multiple:true,
      maximumSelectionSize: 5,
      width:380,
      // placeholder:"asdfasdfsd",
      // allowClear: true,

      formatResult: function (d){
        if(typeof d.group !== "undefined" && d.group) {
          return "<div class='select2-optgroup'>"+d.text+"</div>";
        }
        else {
          return "<div class='logo vtop'><img src='/assets/png/banks/"+d.image+".jpg'/></div><div class='name vtop'>"+d.text+"</div>"; // <div class='abbr'>"+d.id+"</div>
        }
      },
      formatSelection: function (d)
      {
        return "<div title='"+d.text+"' class='logo vtop'><img src='/assets/png/banks/"+d.image+".jpg'/></div>"; //"+d.id+" was replaced with image
      },
      query: function (query) {
        var data = {results:
          [
            {group: true, text: gon.commercial_banks, children: []},
            {group: true, text: gon.micro_finance, children: []}
          ]
        };
        var c = $(".filter-c-currency").select2("val");

        var term = query.term.toUpperCase();
        var len = term.length;

        var e = gon.currency_to_bank[c];
        e.forEach(function (d, i){
          gon.banks.forEach(function (dd, ii){
            if(d == dd[0])
            {
              if(len == 0 || dd[1].toUpperCase().indexOf(term) >= 0 || dd[2].toUpperCase().indexOf(term) >= 0 ){
                data.results[dd[4]].children.push({ id:dd[2], text:dd[1], image:dd[3]["data-image"] });
              }
            }
          });
        });
        query.callback(data);
      },
      initSelection : function (element, callback) {
        var data = [];
        var e = gon.currency_to_bank[$(".filter-c-currency").select2("val")];

        $(element.val().split(",")).each(function (i, d)
        {
          var b = null;
          gon.banks.forEach(function (dd, ii){
            if(d == dd[2] && e.indexOf(dd[0]) != -1)
            {
              data.push({ id:dd[2], text:dd[1], image:dd[3]["data-image"] });
            }
          });
        });
        callback(data);
      }
    });
    $("input.filter-c-bank").on("change", function ()
    {
      c_chart_refresh(false, true);
    });
  }

// renderItem:function(a){var b=this.chart,c=b.renderer,d=this.options,e=d.layout==="horizontal",f=this.symbolWidth,g=d.symbolPadding,h=this.itemStyle,i=this.itemHiddenStyle,j=this.padding,k=e?p(d.itemDistance,20):0,l=!d.rtl,m=d.width,o=d.itemMarginBottom||0,
// q=this.itemMarginTop,t=this.initialItemX,n=a.legendItem,L=a.series&&a.series.drawLegendSymbol?a.series:a,u=L.options,u=this.createCheckboxForItem&&u&&u.showCheckbox,r=d.useHTML;if(this.options.magic || !n){a.legendGroup=c.g("legend-item").attr({zIndex:1}).add(this.scrollGroup);a.legendItem=n=c.text(d.labelFormat?Ma(d.labelFormat,a):d.labelFormatter.call(a),l?f+g:-g,this.baseline||0,r).css(y(a.visible?h:i)).attr({align:l?"left":"right",zIndex:2}).add(a.legendGroup);if(!this.baseline)this.baseline=c.fontMetrics(h.fontSize,
// n).f+3+q,n.attr("y",this.baseline);L.drawLegendSymbol(this,a);this.setItemEvents&&this.setItemEvents(a,n,r,h,i);this.colorizeItem(a,a.visible);u&&this.createCheckboxForItem(a)}c=n.getBBox();f=a.checkboxOffset=d.itemWidth||a.legendItemWidth||f+g+c.width+k+(u?20:0);this.itemHeight=g=w(a.legendItemHeight||c.height);if(e&&this.itemX-t+f>(m||b.chartWidth-2*j-t-d.x))this.itemX=t,this.itemY+=q+this.lastLineHeight+o;this.maxItemWidth=v(this.maxItemWidth,f);this.lastItemY=q+this.itemY+o;this.lastLineHeight=
// v(g,this.lastLineHeight);a._legendItemPos=[this.itemX,this.itemY];e?this.itemX+=f:(this.itemY+=q+g+o,this.lastLineHeight=g);this.offsetWidth=m||v((e?this.itemX-t-k:f)+j,this.offsetWidth)}

// setItemEvents:function(a,b,c,d,e){var f=this;(c?b:a.legendLine).on("mouseover",function(){a.setState("hover");b.css(f.options.itemHoverStyle)}).on("mouseout",function(){b.css(a.visible?d:e);a.setState()});if(!f.options.magic){(c?b:a.legendLine).on("click", function(b){var c=
// function(e){a.setVisible()},b={browserEvent:b};a.firePointEvent?a.firePointEvent("legendItemClick",b,c):K(a,"legendItemClick",b,c)})}}


//bodyFormatter:function(a){var alength = a.length;return xa(a,function(a){var aindex=arguments[1];var c=a.series.tooltipOptions;return(c.pointFormatter||a.point.tooltipFormatter).call(a.point,c.pointFormat,alength,aindex)})}

  function debounce (func, wait, immediate) {
    var timeout;
    return function () {
      var context = this, args = arguments;
      var later = function () {
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
