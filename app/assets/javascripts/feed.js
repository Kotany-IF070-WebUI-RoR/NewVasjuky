"use strict";
function init_users_feed_page() {
    $(window).unload(function () {
        var readed_events = JSON.stringify(get_readed_events_ids());
        $.ajax({
            type: "patch",
            dataType: 'json',
            url: url(),
            data: {readed_events: readed_events}
        });
    });


    function url() {
        var url = window.location.href;
        var usr_url = url.substring(0, url.lastIndexOf('/'));
        return usr_url + '/read_notifications'
    }

    function get_readed_events_ids() {
        var readed_events = $('.post.unread');
        var readed_ids_array = [];
        for(var i = 0; i < readed_events.length; i++) {
            var readed_event_id = $(readed_events[i]).data('event');
            readed_ids_array.push(readed_event_id)
        }
        return readed_ids_array
    }
}


