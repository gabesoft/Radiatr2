// ==UserScript==
// @name           radiatr
// @namespace      me.fabiopereira
// @include        file:///*
// @require   http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.js
// @require   http://ajax.googleapis.com/ajax/libs/jqueryui/1.5.2/jquery-ui.min.js
// @require   http://timeago.yarp.com/jquery.timeago.js

// ==/UserScript==
//

refresh();

(function( $, undefined ) {

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

})(jQuery);


function refresh() {
  hudson();
  $('.status.building').filter(':not(:animated)').effect('pulsate', { times: 1, opacity: 0.5 }, 2000);
  $('.status.buildingFromFailed').filter(':not(:animated)').effect('pulsate', { times: 1, opacity: 0.5 }, 2000);
  setTimeout(refresh, 3000);
}

function hudson() {
  $('.hudson').each(function () {
    this.buildable = true;
    this.wasFailed = false;
		var page = this;
		
		currentBuildStatus(page);
		lastBuildStatus(page);
  });
}

function currentBuildStatus(page) {
	var baseUrl = $('#' + $(page).attr('id') + ' a').attr('href');
	var url = baseUrl + '/lastBuild/api/json';
	var id = '#' + $(page).attr('id');
	
  GM_xmlhttpRequest({
    method: 'GET',
    url: url,
    baseUrl: baseUrl,
    id: id,
    onload: function(response) {
		  var status = JSON.parse(response.responseText);
			updateDashboard(this.id, status);
    }
  });
	
}

function updateDashboard(id, status){
	clearClasses($(id), status);
  $(id).addClass(classToUpdate(status));

	var statusInWords = message(status) + '&nbsp;' + timeDuration(status, id) + differentialTime(status.timestamp);
  $(id + ' span.statusInWords').html(statusInWords);

  var changeSetComment = status.changeSet.items.length > 0 ? status.changeSet.items[0].comment : "Missing Comment!";
  $(id + " span.changeSetComment").html(changeSetComment.substring(0, 140));

  var claim = getClaimObject(status);
	var claimInfo = $(id + " span.claim");
  if(claim) {
    claimInfo.html("Claimed by " + claim.claimedBy + " because " + claim.reason);
		claimInfo.show();
  } else {
    claimInfo.hide();
  }	
}

function getClaimObject(json) {
  for(var i = 0, n = json.actions.length; i < n; i++) {
   if(json.actions[i].claimed) {
     return json.actions[i];
   }
  }
  return null;
}

function lastBuildStatus(page) {
	var self = page;
	var baseUrl = $('#' + $(page).attr('id') + ' a').attr('href');
  var url = baseUrl + '/api/json';
  var id = '#' + $(page).attr('id');

	GM_xmlhttpRequest({
    method: 'GET',
    url: url,
    baseUrl: baseUrl,
    id: id,
    onload: function(response) {
      var status = JSON.parse(response.responseText);
      self.buildable = status.buildable;
      if(!status.buildable){
				markDisabled($(this.id));
      }
      if(status.lastSuccessfulBuild.number < status.lastUnsuccessfulBuild.number) {
        self.wasFailed = true;
				updateClass(status, $(this.id), self.wasFailed);
      }
    }
  });
  
}

function markDisabled(id){
  id.removeClass('success');
  id.removeClass('failure');
  id.removeClass('building');
  id.removeClass('buildingFromFailed');
    
  id.addClass('disabled');
	
}

function updateClass(status, id, wasFailed) {
  if (status.buildable) {
    if(!id.hasClass('building') && !wasFailed) {
		  id.addClass('building');
    } else if (id.hasClass('building') && wasFailed) {
			id.removeClass('building');
		  id.addClass('buildingFromFailed');
    }
    return;
  }
}

function classToUpdate(status, url) {
	if (status.building) {
    return 'building';
  }
  if (isSuccess(status)) {
    return 'success';
  } else {
    return 'failure';
  }
}

function clearClasses(id, status) {
  id.removeClass('building').
     removeClass('failure').
     removeClass('success').
     removeClass('disabled').
     removeClass('buildingFromFailed');
}

function isSuccess(status) {
  return status.result === 'SUCCESS';
}

function message(status) {
  if (status.building) {
    return ' started building';
  } else if (isSuccess(status)) {
    return ' passed';
  } else {
    return numberOfFailures(status) + ' failed';
  }
}

function numberOfFailures(status) {
  var failCount = '0';
  $.each(status.actions, function(i,item){
              if (item.failCount){
           			failCount = item.failCount;
    					}
  });
  return failCount;
}

function timeDuration(status, idPrefix) {
  if (status.building) {
    return '';
  }
  var duration = Math.round((status.duration / 1000 / 60));
  return 'after ' + duration + ' minutes &nbsp;-&nbsp;';
}

function differentialTime(date) {
  timezoneFix = 0 * 60 * 60 * 1000;
  now = new Date()
  diff = now - date + timezoneFix
  millisecondsInDay = 24 * 60 * 60 * 1000
  millisecondsInHour = 60 * 60 * 1000
  millisecondsInMinute = 60 * 1000
  days = 0;
  hours = 0;
  minutes = 0;
  if (diff > millisecondsInDay) {
    days = Math.floor(diff / millisecondsInDay)
    diff = diff - days * millisecondsInDay
  }
  if (diff > millisecondsInHour) {
    hours = Math.floor(diff / millisecondsInHour)
    diff = diff - hours * millisecondsInHour
  }
  if (diff > millisecondsInMinute) {
    minutes = Math.floor(diff / millisecondsInMinute)
  }
  var s = ""
  if (days > 0) {
    s = ", " + days + " day" + (days > 1 ? "s" : "")
  }
  if (hours > 0) {
    s += ", " + hours + " hour" + (hours > 1 ? "s" : "")
  }
  if (minutes > 0 && days == 0) {
    //s += ", " + minutes + " minutes" + (minutes>1 ? "s" : "")
    s += ", " + minutes + " min"
  }
  if (s == "") {
    s = "less than 1 minute ago"
  } else {
    s = s.substring(2) + " ago"
  }
  return s;
}

 
