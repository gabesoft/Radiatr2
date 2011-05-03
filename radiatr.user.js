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
		currentBuildStatus(this);
  });
}

function currentBuildStatus(build) {
	var baseUrl = $('#' + $(build).attr('id') + ' a').attr('href');
	var url = baseUrl + '/lastBuild/api/json';
	var id = '#' + $(build).attr('id');
	
  GM_xmlhttpRequest({
    method: 'GET',
    url: url,
    baseUrl: baseUrl,
    id: id,
    onload: function(response) {
		  var status = JSON.parse(response.responseText);
			jQuery.extend(build, updateDashboard(this.id, status));
			lastBuildStatus(build);
    }
  });
	
}

function updateDashboard(id, status){
	var build = new Object();
	build.status = activity(status);
	build.statusInWords = message(status) + '&nbsp;' + timeDuration(status, id) + differentialTime(status.timestamp);
  var comments = "";
  var commits = status.changeSet.items;
  build.commitCount = commits.length;
  for(var i=0; i < commits.length; i++){
    comments += commits[i].comment + "<br/>";
  }
  if(build.commitCount == 0 ){
    comments = "Missing Comment!!";
  }
  
	build.changeSetComment = comments.substring(0, 140);
  
  var claim = getClaim(status);
  if(claim) {
		build.claim = new Object();
		build.claim.claimedBy = claim.claimedBy;
		build.claim.reason = claim.reason;
  }
	return build;

}

function getClaim(json) {
  for(var i = 0, n = json.actions.length; i < n; i++) {
   if(json.actions[i].claimed) {
     return json.actions[i];
   }
  }
  return null;
}

function lastBuildStatus(build) {
	var self = build;
	var baseUrl = $('#' + $(build).attr('id') + ' a').attr('href');
  var url = baseUrl + '/api/json';
  var id = '#' + $(build).attr('id');

	GM_xmlhttpRequest({
    method: 'GET',
    url: url,
    baseUrl: baseUrl,
    id: id,
    onload: function(response) {
      var status = JSON.parse(response.responseText);
      self.buildable = status.buildable;
      if(!status.buildable){
				build.status = "disabled";
				markDisabled($(this.id));
      } else if(status.lastSuccessfulBuild.number < status.lastUnsuccessfulBuild.number) {	
				if(build.status == 'building'){
				 	build.status = "buildingFromFailed";
				}
      }
			markBuild(build);				
    }
  });
  
}

function markBuild(build){
	var id = '#' + $(build).attr('id');
	clearClasses($(id));
	$(id).addClass(build.status);
	
	$(id + ' span.statusInWords').html(build.statusInWords);
  $(id + " span.changeSetComment").html(build.changeSetComment);
  $(id + ' span.commitCount').html("(" + build.commitCount + ")");

	var claimInfo = $(id + " span.claim");
	if(build.claim) {
  	claimInfo.html("Claimed by " + build.claim.claimedBy + " because " + build.claim.reason);
		claimInfo.show();
	}else {
		claimInfo.hide();
	}
	
}

function markDisabled(id){
  id.removeClass('success');
  id.removeClass('failure');
  id.removeClass('building');
  id.removeClass('buildingFromFailed');
    
  id.addClass('disabled');
	
}

function activity(status) {
	if (status.building) {
    return 'building';
  }
  return status.result === 'SUCCESS' ? 'success' :'failure';
}

function clearClasses(id) {
  id.removeClass('building').
     removeClass('failure').
     removeClass('success').
     removeClass('disabled').
     removeClass('buildingFromFailed');
}

function message(status) {
  if (status.building) {
    return ' started building';
  } else if (status.result === 'SUCCESS') {
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

 
