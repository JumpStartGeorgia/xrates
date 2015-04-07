(function(){
  
  if(!String.prototype.trim)
  {
    String.prototype.trim = function(c) { 
      var r = (!c) ? new RegExp('^\\s+|\\s+$', 'g') : new RegExp('^'+c+'+|'+c+'+$', 'g');
      return this.replace(r, '');
    };
  }
  if(!String.prototype.trimLeft)
  {
    String.prototype.trimLeft = function(c) { 
      var r = (!c) ? new RegExp('^\\s+') : new RegExp('^'+c+'+');
      return this.replace(r, '');
    };
  }
  if(!String.prototype.trimRight)
  {
    String.prototype.trimRight = function(c) { 
      var r = (!c) ? new RegExp('\\s+$') : new RegExp(c+'+$');
      return this.replace(r, '');
    };
  }

})();
function exist(v) { return typeof v !== 'undefined' && v !== null && v !== '';}
function isNumber(v) { return /^\d+$/.test(v); }