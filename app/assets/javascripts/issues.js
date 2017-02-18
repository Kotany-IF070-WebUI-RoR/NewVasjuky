$('document').ready(function () {
    $( ".control_status_panel" ).on( "click", function( event ) {
        if ($(event.target).hasClass('change_status_link')){
            var url = event.target.getAttribute('data-path')
            set_form_action(url)
        }
    });

    function set_form_action(url) {
        var form = $('#add_event_description');
        form.attr('action', url)
    }
});
