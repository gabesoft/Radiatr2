$(document).ready ->
#  $('.building').filter(':not(:animated)').effect('pulsate', { times: 1, opacity: 0.5 }, 2000)
  $.ajax
    method: 'GET'
    url: '/builds'
    success: (data) ->
      console.log data

