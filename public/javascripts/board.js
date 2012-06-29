(function() {
    var createBuildRow, createHeaderRow, getStatusClass, getProgressClass, populateGrid, progress, progress_value, tick;

    getStatusClass = function(build) {
        var result;

        switch (build.status) {
            case 'FAILURE':
                result = 'fail';
                break;
            case 'UNSTABLE':
                result = 'unstable';
                break;
            case 'SUCCESS':
                result = 'success';
                break;
            default:
                result = '';
        }

        if (build.building) { 
            result += ' building';
        }

        return result;
    };

    getProgressClass = function(build) {
        if (build.building) {
            return 'progress building';
        } else {
            return 'progress';
        }
    };

    getTimeClass = function(build) {
        return build.building ? 'time-hidden' : 'time-visible';
    };

    createBuildRow = function(build) {
        var rowTmpl     = $('#row-tmpl').text();
        var commentTmpl = $('#comment-tmpl').text();

        var row = Mustache.render(rowTmpl, {
                statusCls: getStatusClass(build)
              , job: build.job
              , health: build.health
              , duration: build.duration
              , timeCls: getTimeClass(build)
              , progressBuildCls: getProgressClass(build)
              , progressValueCls: 'progressbar-' + build.progress
              , time: build.time_human
              , failures: build.failures
            });

        var comment = '';

        if (build.status === 'FAILURE' && build.comments) {
            comment = Mustache.render(commentTmpl, { comments: build.comments });
        }

        return row + comment;
    };

    createHeaderRow = function() {
        var header = $('#header-tmpl').text();
        return Mustache.render(header);
    };

    progress_value = function(progress) {
        if (progress < 100) {
            return progress;
        } else {
            return 0;
        }
    };

    progress = function(progress) {
        return $('.progressbar-' + progress).progressbar({
            value: progress_value(progress)
        });
    };

    populateGrid = function(data) {
        var build, _i, _len, _ref;

        $('#grid').text('');
        $('#grid').append(createHeaderRow());
        _ref = JSON.parse(data).builds;

        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            build = _ref[_i];
            $('#grid').append(createBuildRow(build));
            progress(build.progress);
        }

        return $('.building').filter(':not(:animated)').effect('pulsate', {
            times: 1,
            opacity: 0.5
        }, 2000);
    };

    tick = function() {
        return $.ajax({
            method: 'GET',
            url: '/builds',
            success: populateGrid
        });
    };

    $(document).ready(function() {
        return setInterval(tick, 3000);
    });

}).call(this);
