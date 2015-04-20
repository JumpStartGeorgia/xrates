var dev = true;
if(gon.dev || dev)
{
  var firstResize = true;
  $(window).resize(function(){
    var t = null; 
    if(firstResize)
    {
      t = $("<div class='js-dev-windows-size h'></div>");
      $('body').append(t);  
      t.css({"position":"fixed","right":"0px","bottom":"0px", "background-color":"#fff","color":"#000","padding":"6px 10px","font-size":"14px","font-family":"monospace"});
      firstResize = false;
    }
    t = $(document).find('.js-dev-windows-size');
    var w = window.innerWidth;
    var h = window.innerHeight;
    t.html(w+"px / "+h+ "px");
    if(t.hasClass('h'))
    {
      t.toggleClass('h').fadeIn(1000).delay(5000).fadeOut(1000,function(){ t.toggleClass('h'); });
    }
  });
}