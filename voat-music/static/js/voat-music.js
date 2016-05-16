$(document).ready(function(){
  var dataUrl = "http://vp.music-data.ir:9001/api/v1/voat/subverses/"

  nextPage = function () {
    postvue.currentPage = postvue.currentPage + 1;
    getPosts();
  }
  prevPage = function () {
    postvue.currentPage = postvue.currentPage - 1;
    getPosts();
  }
  
  getPosts = function () {
    postvue.bannerMsg = "";
    $("#pageNum").hide();
    $("#loadingIcon").show();
    $.ajax({
      url: dataUrl,
      type: 'GET',
      data: {
        limit: postvue.itemsPerPage, 
        start: (postvue.currentPage - 1 ) * postvue.itemsPerPage,
        subverse: postvue.subverse,
      },
      dataType: 'json',
      success: function(data) { postvue.posts = data; $("#loadingIcon").hide(); $("#pageNum").show();},
      error: function() { postvue.bannerMsg = "There was a problem loading the music... try again"; $("#loadingIcon").hide(); $("#pageNum").show(); },
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
      subverse: "music"
    },
  });
  
  // On first page load, do ajax
  getPosts();
  $("#nextPageTop").click(function(){ nextPage(); });
  $("#prevPageTop").click(function(){ prevPage(); });
  $("#nextPageBottom").click(function(){ nextPage(); });
  $("#prevPageBottom").click(function(){ prevPage(); });
  $("#goBtn").click(function(){ postvue.currentPage = 1; getPosts(); });
  $("#submitSearch").keyup(function (e) {
    if (e.keyCode == 13) {
      postvue.currentPage = 1;
      getPosts();
  }});
  
});
