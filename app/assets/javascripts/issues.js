
function initIssuesMap() {
  initGoogleLayer();
  var map = new L.Map('issues-map', { center: new L.LatLng(48.920597, 24.709566), zoom: 14 }),
      googleLayer = new L.Google('ROADMAP');

  map.addLayer(googleLayer);
  
  $.get({url: '/issues/map', dataType:"json", cache:false}).done(addMarkers);


  function addMarkers(issues) {
    var bounds = [];

    issues.forEach(function(issue){
      var coords = [issue.latitude, issue.longitude],
          marker = L.marker(coords).addTo(map);

      bounds.push(coords)
      handlePopup(marker, issue.id);
    });

    map.fitBounds(bounds);
  }
      
  function handlePopup(marker, id){
    marker.bindPopup("Завантаження...")
    marker.on('click', function(e) {
      var popup = e.target.getPopup(),
          url="/issues/"+ id + "/popup/" ;
      $.get({url: url, dataType:"json"})
        .done(function(issue) {
          var shortDescription = truncate(issue.description, 90, true),
              popupLayout = '<h4>'+issue.title+'</h4>'+
                            '<img src="'+ issue.img.url +'">'+
                            '<p>'+shortDescription+'</p>'+
                            '<p><span>'+issue.created_at+'<span><a class="pull-right" href="/issues/'+id+'">Переглянути</a></p>';
          popup.setContent(popupLayout);
          popup.update();
        })
        .fail(function (jqXHR) {
          popup.setContent(jqXHR.responseJSON.error);
          popup.update();
        })
    });
  }
}

function truncate(s, n, useWordBoundary){
    var isTooLong = s.length > n;
        s = isTooLong ? s.substr(0,n-1) : s;
        s = (useWordBoundary && isTooLong) ? s.substr(0,s.lastIndexOf(' ')) : s;
    return  isTooLong ? s + '&hellip;' : s;
}
