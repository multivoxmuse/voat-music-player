$(document).ready(function(){
  var VoatAPI = "https://voat.co/api/subversefrontpage?subverse=music"
  var dataUrl = "http://vp.music-data.ir:9001/api/v1/voat/subverses/music/"

  var getyturl = {
    yturl: 'https://www.youtube.com/embed/wyPfrbJKMpg'
  }

  nextPage = function () {
    postvue.currentPage = postvue.currentPage + 1;
    getPosts();
  }
  prevPage = function () {
    postvue.currentPage = postvue.currentPage - 1;
    getPosts();
  }
  
  getPosts = function () {
    $.ajax({
      url: dataUrl,
      type: 'GET',
      data: {
        limit: postvue.itemsPerPage, 
        start: (postvue.currentPage - 1 ) * postvue.itemsPerPage 
      },
      dataType: 'json',
      success: function(data) { postvue.posts = data; },
      error: function() { postvue.bannerMsg = "There was a problem loading the music... try again"; },
      beforeSend: function(xhr){ 
        xhr.setRequestHeader("Content-Type","application/json");
        xhr.setRequestHeader("Accept","application/json");
      }
    });
  }

  var postvue = new Vue({
    el: '#posts',
    data: {
      posts: [],
      currentPage: 1,
      itemsPerPage: 4,
      bannerMsg: "",
    },
  });
  
  // On first page load, do ajax
  getPosts();
  $("#nextPage").click(function(){ nextPage(); });
  $("#prevPage").click(function(){ prevPage(); });
});
