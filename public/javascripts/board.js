(function() {
  var createBuildRow, getStatusClass, populateGrid, tick;
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
  createBuildRow = function(build) {
    var result;
    result = "<tr>";
    result += "<th>Job Name</th>";
    result += "<th>Health</th>";
    result += "<th>Project</th>";
    result += "<th>Committers</th>";
    return result += "</tr>";
  };
  populateGrid = function(data) {
    var build, _i, _len, _ref, _results;
    $('#grid').append(createHeaderRow());
    _ref = JSON.parse(data).builds;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      build = _ref[_i];
      _results.push($('#grid').append(createBuildRow(build)));
    }
    return _results;
  };
  tick = function() {
    return $.ajax({
      method: 'GET',
      url: '/builds',
      success: populateGrid
    });
  };
  $(document).ready(function() {
    return setInterval(tick, 1000);
  });
}).call(this);
