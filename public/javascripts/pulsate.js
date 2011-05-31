$.effects.pulsate = function(o) {
	return this.queue(function() {
		var elem = $(this),
			mode = $.effects.setMode(elem, o.options.mode || 'show'),
			times = ((o.options.times || 5) * 2) - 1,
			duration = o.duration ? o.duration / 2 : $.fx.speeds._default / 2,
			isVisible = elem.is(':visible'),
			opacity = o.options.opacity || 0,
			animateTo = 0,
			i = 0;

		if (!isVisible) {
			elem.css('opacity', opacity).show();
			animateTo = 1;
		}

		if ((mode === 'hide' && isVisible) || (mode === 'show' && !isVisible)) {
			times--;
		}

		for (i = 0; i < times; i++) {
			elem.animate({ opacity: animateTo === 1 ? 1 : opacity }, duration, o.options.easing);
			animateTo = (animateTo + 1) % 2;
		}

		elem.animate({ opacity: animateTo === 1 ? 1 : opacity }, duration, o.options.easing, function() {
			(o.callback && o.callback.apply(this, arguments));
		});

		elem
			.queue('fx', function() { elem.dequeue(); })
			.dequeue();
	});
};

