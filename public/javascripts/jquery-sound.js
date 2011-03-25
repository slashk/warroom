(function($) {
$.sound = {
	tracks: {},
	enabled: true,
	template: function(src) {
		return '&lt;embed style="height:0" loop="false" src="' + src + '" autostart="true" hidden="true"/&gt;';
	},
	play: function(url, options){
		if (!this.enabled)
			return;
		var settings = $.extend({
			url: url,
			timeout: 2000
		}, options);
		if(settings.track){
			if (this.tracks[settings.track]) {
				var current = this.tracks[settings.track];
				current.Stop && current.Stop();
				current.remove();
			}
		}
		var element = $.browser.msie
		  	? $('&lt;bgsound/&gt;').attr({
		        src: settings.url,
				loop: 1,
				autostart: true
		      })
		  	: $(this.template(settings.url));
		element.appendTo("body");
		if (settings.track) {
			this.tracks[settings.track] = element;
		}
		setTimeout(function() {
			element.remove();
		}, options.timeout)
		return element;
	}
};
})(jQuery);