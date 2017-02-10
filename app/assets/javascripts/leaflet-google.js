// L.TileLayer is used for standard xyz-numbered tile layers.
function initGoogleLayer (){
  L.Google = L.Class.extend({
    includes: L.Mixin.Events,

    options: {
      minZoom: 0,
      maxZoom: 18,
      tileSize: 256,
      subdomains: 'abc',
      errorTileUrl: '',
      attribution: '',
      opacity: 1,
      continuousWorld: false,
      noWrap: false
    },

    // Possible types: SATELLITE, ROADMAP, HYBRID
    initialize: function(type, options) {
      L.Util.setOptions(this, options);

      this._type = google.maps.MapTypeId[type || 'SATELLITE'];
    },

    onAdd: function(map, insertAtTheBottom) {
      this._map = map;
      this._insertAtTheBottom = insertAtTheBottom;

      // create a container div for tiles
      this._initContainer();
      this._initMapObject();

      // set up events
      map.on('viewreset', this._resetCallback, this);

      this._limitedUpdate = L.Util.limitExecByInterval(this._update, 150, this);
      map.on('move', this._update, this);
      //map.on('moveend', this._update, this);

      this._reset();
      this._update();
    },

    onRemove: function(map) {
      this._map._container.removeChild(this._container);
      //this._container = null;

      this._map.off('viewreset', this._resetCallback, this);

      this._map.off('move', this._update, this);
      //this._map.off('moveend', this._update, this);
    },

    getAttribution: function() {
      return this.options.attribution;
    },

    setOpacity: function(opacity) {
      this.options.opacity = opacity;
      if (opacity < 1) {
        L.DomUtil.setOpacity(this._container, opacity);
      }
    },

    _initContainer: function() {
      var tilePane = this._map._container
        first = tilePane.firstChild;

      if (!this._container) {
        this._container = L.DomUtil.create('div', 'leaflet-google-layer leaflet-top leaflet-left');
        this._container.id = "_GMapContainer";
      }

      tilePane.insertBefore(this._container, first);

      this.setOpacity(this.options.opacity);
      var size = this._map.getSize();
      this._container.style.width = size.x + 'px';
      this._container.style.height = size.y + 'px';
    },

    _initMapObject: function() {
      this._google_center = new google.maps.LatLng(0, 0);
      var map = new google.maps.Map(this._container, {
          center: this._google_center,
          zoom: 0,
          mapTypeId: this._type,
          disableDefaultUI: true,
          keyboardShortcuts: false,
          draggable: false,
          disableDoubleClickZoom: true,
          scrollwheel: false,
          streetViewControl: false
      });

      var _this = this;
      this._reposition = google.maps.event.addListenerOnce(map, "center_changed", 
        function() { _this.onReposition(); });
    
      map.backgroundColor = '#ff0000';
      this._google = map;
    },

    _resetCallback: function(e) {
      this._reset(e.hard);
    },

    _reset: function(clearOldContainer) {
      this._initContainer();
    },

    _update: function() {
      this._resize();

      var bounds = this._map.getBounds();
      var ne = bounds.getNorthEast();
      var sw = bounds.getSouthWest();
      var google_bounds = new google.maps.LatLngBounds(
        new google.maps.LatLng(sw.lat, sw.lng),
        new google.maps.LatLng(ne.lat, ne.lng)
      );
      var center = this._map.getCenter();
      var _center = new google.maps.LatLng(center.lat, center.lng);

      this._google.setCenter(_center);
      this._google.setZoom(this._map.getZoom());
      //this._google.fitBounds(google_bounds);
    },

    _resize: function() {
      var size = this._map.getSize();
      if (this._container.style.width === size.x &&
          this._container.style.height === size.y)
        return;
      this._container.style.width = size.x + 'px';
      this._container.style.height = size.y + 'px';
      google.maps.event.trigger(this._google, "resize");
    },

    onReposition: function() {
      //google.maps.event.trigger(this._google, "resize");
    }
  });
}

// Initialize map with google maps layer
function initLayers(){
  initGoogleLayer();
  var map = new L.Map('map-container', { center: new L.LatLng(48.920597, 24.709566), zoom: 14 }),
      googleLayer = new L.Google('ROADMAP');
  map.addLayer(googleLayer);
  return map;
}

// Only for 'Show' page
function showIssueMap(lat,lng){
  var map = initLayers(),
      marker = new L.marker([lat,lng]).addTo(map);
  map.panTo(marker._latlng);
}

// Only for 'Edit' page
function editIssueMap(lat,lng){
  var map = initLayers(),
      marker = new L.marker([lat,lng],{draggable:true}).addTo(map);
  map.panTo(marker._latlng);
  bindMarkerEvents(map,marker);
  bindAutocomplete(map, marker);
}

function setCoordinates(lat,lng){
  if ($("#issue_latitude").length){
    $("#issue_latitude").val(lat);
    $("#issue_longitude").val(lng);
  }
}

function bindMarkerEvents(map,marker){
  marker.on("dragend",function(e){
    var newPos = e.target._latlng;
    getReverseGeocodingData(newPos.lat,newPos.lng)
    setCoordinates(newPos.lat,newPos.lng);
  });
  map.on('click', function(e){
    var newPos = e.latlng;
    marker.setLatLng([newPos.lat,newPos.lng]);
    getReverseGeocodingData(newPos.lat, newPos.lng);
    setCoordinates(newPos.lat,newPos.lng);
    $('.leaflet-objects-pane').removeClass('hidden');
  });
}

// Only for 'New' page
function newIssueMap(){
  var map = initLayers();
      marker = new L.marker([48.920597, 24.709566],{draggable:true}).addTo(map);
  $('.leaflet-objects-pane').addClass('hidden');
  bindMarkerEvents(map,marker);
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position){
      onGeocodeSuccess(map,marker,position)
    }, function(msg){
      onGeocodeError(map,marker,msg)
    });
  }
} 

function onGeocodeSuccess(map, marker, position) {
  var lat = position.coords.latitude,
      lng = position.coords.longitude;
  marker.setLatLng([lat,lng]);
  map.panTo(marker._latlng);
  $('.leaflet-objects-pane').removeClass('hidden');
  getReverseGeocodingData(lat,lng);
  bindAutocomplete(map,marker);
}

function onGeocodeError(map, marker, msg) {
  console.log(msg);
  $('#issue_location').attr('placeholder', 'Введіть адресу проблеми');
  bindAutocomplete(map,marker);
}

// Synchronize autocomplete events with map
function bindAutocomplete(map,marker){
  var input = document.getElementById('issue_location'),
      autocomplete = new google.maps.places.Autocomplete(input);
  google.maps.event.addListener(autocomplete, 'place_changed', function() {  
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      return;
    } else {
      var lat = place.geometry.location.lat(),
          lng = place.geometry.location.lng();
      marker.setLatLng([lat,lng]);
      $('.leaflet-objects-pane').removeClass('hidden');
      map.panTo(marker._latlng);
      setCoordinates(lat,lng);
    }
  }); 
}

// Fill only location textfield with formatted geodata
function getReverseGeocodingData(lat, lng) {
  var geocoder, latlng;
  latlng = new google.maps.LatLng(lat, lng);
  geocoder = new google.maps.Geocoder;
  geocoder.geocode( {'latLng': latlng}, function(results, status) {
      if (status === google.maps.GeocoderStatus.OK) {
          var location = results[0].formatted_address;
          $("#issue_location").val(location);
      }
  });
}

// Only for 'issues/map' page
function initIssuesMap(){
  var map = initLayers();
  $.get({url: '/issues/map', dataType:"json", cache:false}).done(function(issues){
    addMarkers(map,issues)
  });
}

// Add markers for every issue
function addMarkers(map, issues) {
  var bounds = [];

  issues.forEach(function(issue){
    var coords = [issue.latitude, issue.longitude],
        marker = L.marker(coords).addTo(map);

    bounds.push(coords)
    handlePopup(marker, issue.id);
  });

  map.fitBounds(bounds);
}

// Handle popup on every marker
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

// Truncate _strings for a _number of letters
function truncate(s, n, useWordBoundary){
    var isTooLong = s.length > n;
        s = isTooLong ? s.substr(0,n-1) : s;
        s = (useWordBoundary && isTooLong) ? s.substr(0,s.lastIndexOf(' ')) : s;
    return  isTooLong ? s + '&hellip;' : s;
}