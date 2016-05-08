$(document).ready(function(){
  var VoatAPI = "https://voat.co/api/subversefrontpage?subverse=music"

  var getyturl = {
    yturl: 'https://www.youtube.com/embed/wyPfrbJKMpg'
  }

  var postvue = new Vue({
    el: '#posts',
    data: {
      posts: {}
    }
  });

  $.ajax({
    url: VoatAPI,
    type: 'GET',
    dataType: 'json',
    success: function(data) { console.log('hello!'); },
    error: function() { console.log('boo!'); },
    beforeSend: function(xhr){ 
      xhr.setRequestHeader("Content-Type","application/json");
      xhr.setRequestHeader("Accept","application/json");
    }
  });

});
