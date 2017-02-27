function render_errors(errors_json, form, name_prefix) {
    var errors = JSON.parse(errors_json);
    for (var key in errors) {
        if (errors.hasOwnProperty(key)) {
            var error_block = $(form).find('[name="' + name_prefix + '[' + key +
                ']"]').parent();
            var error_text = errors[key][0];
            add_error_status(error_block, error_text);
        }
    }
}

function add_error_status(error_block, error_text) {
    if ($(error_block).find('.help-block').length !== 0) return;
    $(error_block).append('<span class="help-block">' + error_text + '</span>');
    $(error_block).addClass('has-error');
}

function remove_error_status(form) {
    var form_errors = $(form).find('.has-error');
    if (form_errors.length === 0) return;
    $(form_errors).each(function () {
        $(this).removeClass('has-error');
        $(this).find('.help-block').remove();
    })
}