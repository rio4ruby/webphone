(function($){
  $.widget("rtc.session", {
    options: {
      e911id: "",
      access_token: "",
      gw_url: "https://api.att.com",
      register_path: '/RTC/v1/sessions'
    },
    
    _create: function(){
      console.log("_create")
    },
    _url: function() {
      this.options.gw_url + this.options.register_path
    },
    start: function(){
      var rtc = this;
      jQuery.ajax(this._url(), {
        method: 'POST',
        dataType: 'json',
        accepts: 'application/json',
        contentType: 'application/json; charset=UTF-8',
        beforeSend: function() {
          rtc._set_ident_headers(this);
        },
        data: { session: rtc._data }
      })
        .done(function(data, textStatus, jqXHR) {
          console.log("DONE: " + textStatus);
          console.log(data);
          console.log(jqXHR);
        })
        .fail(function(jqXHR, textStatus, errorThrown) {
          console.log("FAIL: " + textStatus);
          console.log(errorThrown);
          console.log(jqXHR);
        });
    },
    _data: {
      mediaType: "dtls-srtp",
      ice:  "true",
      services: [
	"ip_voice_call",
	"ip_video_call"
      ]
    },
    _set_ident_headers: function(jqXHR) {
      jqXHR.headers({
        'Authorization': 'Bearer ' + this.options.access_token,
        'x-e911id': this.options.e911id;
      });
    },
    _setOption: function( key, value ) {
      this._super( key, value );
    },
    _setOptions: function( options ) {
      this._super( options );
    },
  });
  
})(jQuery);
