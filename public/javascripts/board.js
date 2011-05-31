(function() {
  $(document).ready(function() {
    return $('.building').filter(':not(:animated)').effect('pulsate', {
      times: 1,
      opacity: 0.5
    }, 2000);
  });
}).call(this);
