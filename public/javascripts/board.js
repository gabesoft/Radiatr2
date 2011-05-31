(function() {
  var createBuildRow, createHeaderRow, getStatusClass, populateGrid, tick;
  getStatusClass = function(build) {
    var result;
    result = build.status === 'Fail' ? 'fail' : 'success';
    if (build.building) {
      result += ' building';
    }
    return result;
  };
  createBuildRow = function(build) {
    var result;
    result = "<tr class='" + getStatusClass(build) + "'>";
    result += "<td>" + build.job + "</td>";
    result += "<td>" + build.health + "</td>";
    result += "<td>" + build.project + "</td>";
    result += "<td>" + build.committers + "</td>";
    return result += "</tr>";
  };
  createHeaderRow = function() {
    var result;
    result = "<tr>";
    result += "<th>Job Name</th>";
    result += "<th>Health</th>";
    result += "<th>Project</th>";
    result += "<th>Committers</th>";
    return result += "</tr>";
  };
  populateGrid = function(data) {
    var build, _i, _len, _ref;
    $('#grid').text('');
    $('#grid').append(createHeaderRow());
    _ref = JSON.parse(data).builds;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      build = _ref[_i];
      $('#grid').append(createBuildRow(build));
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
