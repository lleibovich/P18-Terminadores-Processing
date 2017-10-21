(function ($) {
	$.fn.onEnter = function (func) {
		this.bind('keypress', function (e) {
			if (e.keyCode == 13) func.apply(this, [e]);
		});
		return this;
	};
})(jQuery);