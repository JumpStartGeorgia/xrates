(function(){
  
  if(!String.prototype.trim)
  {
    String.prototype.trim = function(c) { 
      var r = (!c) ? new RegExp('^\\s+|\\s+$', 'g') : new RegExp('^'+c+'+|'+c+'+$', 'g');
      return this.replace(r, '');
    };
  }
  if(!String.prototype.triml)
  {
    String.prototype.triml = function(c) { 
      var r = (!c) ? new RegExp('^\\s+') : new RegExp('^'+c+'+');
      return this.replace(r, '');
    };
  }
  if(!String.prototype.trimr)
  {
    String.prototype.trimr = function(c) { 
      var r = (!c) ? new RegExp('\\s+$') : new RegExp(c+'+$');
      return this.replace(r, '');
    };
  }
  // if(!Number.prototype.toLocaleString)
  // {
  //   String.prototype.toLocaleString = function(c) { 
  //     return "blah";
  //     // var r = (!c) ? new RegExp('^\\s+') : new RegExp('^'+c+'+');
  //     // return this.replace(r, '');
  //   };
  // }

})();
function exist(v) { return typeof v !== 'undefined' && v !== null && v !== '';}
function isNumber(v) { return /^\d+$/.test(v); }