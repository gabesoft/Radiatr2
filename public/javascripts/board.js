(function(){
  var createBuildRow, createHeaderRow, getStatusClass, populateGrid, tick;
  getStatusClass = function(build) {
    var _a, result;
    if ((_a = build.status) === 'FAILURE') {
      result = 'fail';
    } else if (_a === 'SUCCESS') {
      result = 'success';
    } else {
      result = '';
    }
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
    result += "<td>" + build.duration + "</td>";
    return result += "</tr>";
  };
  createHeaderRow = function() {
    var result;
    result = "<tr>";
    result += "<th>Job Name</th>";
    result += "<th>Health</th>";
    result += "<th>Project</th>";
    result += "<th>Duration</th>";
    return result += "</tr>";
  };
  populateGrid = function(data) {
    var _a, _b, _c, build;
    $('#grid').text('');
    $('#grid').append(createHeaderRow());
    _b = JSON.parse(data).builds;
    for (_a = 0, _c = _b.length; _a < _c; _a++) {
      build = _b[_a];
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
})();
