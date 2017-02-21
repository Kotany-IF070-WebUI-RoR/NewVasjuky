function init_change_status_form() {
    $("#add_event_description").on("ajax:success", function (e, data, status, xhr) {
        location.reload()
    }).on("ajax:error", function (e, xhr, status, error) {
        remove_error_status(this);
        render_errors(xhr.responseText, this, 'event');
    });
}