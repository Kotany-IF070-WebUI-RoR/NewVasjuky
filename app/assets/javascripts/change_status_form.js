function init_change_status_form() {
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

    $("#event_image").change(function(){
        $('#img_prev').removeClass('hidden');
        readURL(this);
    });

    // helpers

    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#img_prev').attr('src', e.target.result);
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

}
