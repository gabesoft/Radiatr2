(function() {
    var createBuildRow, createHeaderRow, getStatusClass, getBuildClass, populateGrid, progress, progress_value, tick;

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
        if (build.building) result += ' building';
        return result;
    };

    getBuildClass = function(build) {
        if (build.building) {
            return 'progress building';
        } else {
            return 'progress';
        }
    };

    createBuildRow = function(build) {
        var result;

        // TODO: display build date
        //       add timestamp like : a day ago, etc
        //       change duration format to hh:mm:ss
        //console.log(new Date(build.timestamp));
        //       delete coffee/ + all unused files !!
        //       rename getBuildClass to getProgressClass

        var rowTmpl     = $('#row-tmpl').text();
        var commentTmpl = $('#comment-tmpl').text();

        var row = Mustache.render(rowTmpl, {
                statusCls: getStatusClass(build)
              , job: build.job
              , health: build.health
              , duration: build.duration
              , progressBuildCls: getBuildClass(build)
              , progressValueCls: 'progressbar-' + build.progress
              , failures: build.failures
            });

        var comment = '';

        if (build.status === 'FAILURE' && build.comments) {
            comment = Mustache.render(commentTmpl, { comments: build.comments });
        }



        //result = "<tr class='" + getStatusClass(build) + "'>";
        //result += "<td>" + build.job + "</td>";
        //result += "<td>" + build.health + "</td>";
        //result += "<td >" + build.duration;
        //result += "<div class='" + getBuildClass(build) + "'>";
        //result += "<div class='progressbar-" + build.progress + "'>" + "</div>";
        //result += "</div>";
        //result += "</td>";
        //result += "<td>" + build.failures + "</td>";
        //result += "</tr>";
        if (build.status === 'FAILURE' && build.comments) {
            result += "<tr class='comment'>";
            result += "<td colspan=4>" + build.comments + "</td>";
            result += "</tr>";
        }

        return row + comment;
        //return result;
    };

    createHeaderRow = function() {
        var result;
        result = "<tr>";
        result += "<th>Job Name</th>";
        result += "<th>Health</th>";
        result += "<th>Duration</th>";
        result += "<th>Failures</th>";
        result += "</tr>";
        return result;
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
