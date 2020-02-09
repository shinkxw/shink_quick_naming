window.cal_and_set_css = function cal_and_set_css(){
  var height = $(window).height();
  $('.adaptive_height_dlg').height((height));
}

window.prevent_f5 = function prevent_f5(){
  $("body").bind("keydown",function(e){
    e = window.event || e;
    if(event.keyCode==116){
      if(window.event){// ie
        try{e.keyCode = 0;}catch(e){}
        e.returnValue = false;
      }else{// firefox
        e.preventDefault();
      }
    }
  });
}

window.prevent_backspace = function prevent_backspace(){
  document.onkeydown = function() {
    if (event.keyCode == 8) {
      if (document.activeElement.type == "text" && document.activeElement.readOnly == false) {
        return true;
      }
      if (document.activeElement.type == "password") { return true; }
      if (document.activeElement.type == "textarea") { return true; }
      return false;
    }
  }
}

window.getQueryString = function getQueryString(name) {
  var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
  var r = window.location.search.substr(1).match(reg);
  if (r != null) return unescape(r[2]); return null;
}

window.su_alert = function su_alert(message) {
  if (window.in_su) {
    su_location('alert', {message: message})
  }else{
    alert(message)
  }
}

window.su_location = function su_location(name, params = false){
  if (params) {
    zlib.deflate(window.JSON.stringify(params), (err, buffer) => {
      window.location = 'skp:' + name + '@' + buffer.toString('base64')
    });
  }
  else {
    window.location = 'skp:' + name
  }
}
