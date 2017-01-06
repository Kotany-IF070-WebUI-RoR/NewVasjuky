$(document).ready(function() {
    var error, getReverseGeocodingData, success;
    error = function(msg) {
        $('#issue_location').val('Введіть адресу проблеми');
    };
    success = function(position) {
         getReverseGeocodingData(position.coords.latitude, position.coords.longitude);
    };
    getReverseGeocodingData = function(lat, lng) {
        var geocoder, latlng;
        latlng = new google.maps.LatLng(lat, lng);
        geocoder = new google.maps.Geocoder;
        geocoder.geocode({
            'latLng': latlng
        }, function(results, status) {
            var location;
            if (status === google.maps.GeocoderStatus.OK) {
                location = results[0].formatted_address;
                $("#issue_location").val(location);
            }
        });
    };
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(success, error);
    }
});