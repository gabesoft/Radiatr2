getStatusClass = (build) ->
  switch build.status
    when 'FAILURE' then result = 'fail'
    when 'SUCCESS' then result = 'success'
    else result = ''
  result += ' building' if build.building
  result

createBuildRow = (build) ->
  result = "<tr class='" + getStatusClass(build) + "'>"
  result += "<td>" + build.job + "</td>"
  result += "<td>" + build.health + "</td>"
  result += "<td class='progressbar-" + build.progress + "'>" + build.duration + "</td>"
  result += "<td>" + build.failures + "</td>"
  result += "</tr>"
  if(build.status == 'FAILURE')
    result += "<tr class='comment'>"
    result += "<td colspan=4>" + build.comments + "</td>"
    result += "</tr>"
  result

createHeaderRow = ->
  result = "<tr>"
  result += "<th>Job Name</th>"
  result += "<th>Health</th>"
  result += "<th>Duration</th>"
  result += "<th>Failures</th>"
  result += "</tr>"

progress_value = (progress) ->
  if progress < 100 then progress else 0

progress = (progress) ->
  $('.progressbar-'+progress).progressbar({ value: progress_value(progress) })

populateGrid = (data) ->
  $('#grid').text ''
  $('#grid').append createHeaderRow()
  for build in JSON.parse(data).builds
    $('#grid').append createBuildRow build
    progress(build.progress)
  $('.building').filter(':not(:animated)').effect('pulsate', { times: 1, opacity: 0.5 }, 2000)

tick = ->
  $.ajax {
    method: 'GET'
    url: '/builds'
    success: populateGrid
  }

$(document).ready -> setInterval tick, 3000
