getStatusClass = (build) ->
  result = if build.status == 'Fail' then 'fail' else 'success'
  result += ' building' if build.building
  result

createBuildRow = (build) ->
  result = "<tr class='" + getStatusClass(build) + "'>"
  result += "<td>" + build.job + "</td>"
  result += "<td>" + build.health + "</td>"
  result += "<td>" + build.project + "</td>"
  result += "<td>" + build.committers + "</td>"
  result += "</tr>"

populateGrid = (data) ->
  for build in JSON.parse(data).builds
    $('#grid').append createBuildRow build

$(document).ready ->
#  $('.building').filter(':not(:animated)').effect('pulsate', { times: 1, opacity: 0.5 }, 2000)
  $.ajax
    method: 'GET'
    url: '/builds'
    success: populateGrid

