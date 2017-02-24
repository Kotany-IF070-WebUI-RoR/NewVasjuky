function init_change_status_form() {
    $("#add_event_description").on("ajax:success", function (e, data, status, xhr) {
        location.reload();
    }).on("ajax:error", function (e, xhr, status, error) {
        remove_error_status(this);
        render_errors(xhr.responseText, this, 'event');
    });

    $( ".control_status_panel" ).on( "click", function( event ) {
        if ($(event.target).hasClass('change_status_link')){
            var url = event.target.getAttribute('data-path');
            set_form_action(url)
        }
    });

    function set_form_action(url) {
        var form = $('#add_event_description');
        form.attr('action', url)
    }
}
