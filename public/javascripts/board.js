(function() {
  $(document).ready(function() {
    return $.ajax({
      method: 'GET',
      url: '/builds',
      success: function(data) {
        return console.log(data);
      }
    });
  });
}).call(this);
