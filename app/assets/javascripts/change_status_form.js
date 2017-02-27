function init_change_status_form() {
    $( ".control_status_panel" ).on( "click", function( event ) {
        if ($(event.target).hasClass('change_status_link')){
            var url = event.target.getAttribute('data-path');
            set_form_action(url)
        }
    });

    $("#event_image").change(function(){
        $('#img_prev').attr('src', '').addClass('hidden');
        load_preview(this);
        validateFiles(this)
    });

    // helpers

    function set_form_action(url) {
        var form = $('#add_event_description');
        form.attr('action', url)
    }

    function load_preview(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#img_prev').attr('src', e.target.result).removeClass('hidden');
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    function validateFiles(inputFile) {
        var errors = get_errors(inputFile.files, $(inputFile).data('max-file-size'));
        if (errors.length > 0) {
            $('#submit-event').prop('disabled', true);
            flash_messages(errors)
        }
        else if (errors.length === 0) {
            $('#submit-event').prop('disabled', false);
        }
    }

    function get_errors(files, maxFileSize) {
        var extName;
        var maxFileSizeInMb = bytesToSize(maxFileSize);

        var maxExceededMessage = "Максимальний розмір зображення " +
            maxFileSizeInMb + '.';
        var allowedExtension = ["jpg", "jpeg", "gif", "png"];
        var extErrorMessage = "Фото може бути тільки в наступних форматах: " +
            allowedExtension.join(", ") + ".";
        var errors = [];

        $.each(files, function() {
            if (this.size && maxFileSize && this.size > parseInt(maxFileSize, 10)) {
                errors.push(maxExceededMessage)
            }

            extName = this.name.split('.').pop();
            if ($.inArray(extName, allowedExtension) === -1) {
                errors.push(extErrorMessage)
            }
        });
        return errors
    }

    function flash_messages(errors_messages){
        UnobtrusiveFlash.showFlashMessage(errors_messages.join(' '),
            {type: 'warning'});
    }

    function bytesToSize(bytes) {
        var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
        if (bytes === 0) return 'n/a';
        var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)), 10);
        if (i === 0) return bytes + ' ' + sizes[i] + ')';
        return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + sizes[i];
    }

}
