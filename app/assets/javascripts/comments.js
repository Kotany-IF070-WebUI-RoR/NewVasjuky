"use strict";
function init_comments_page() {
    // Comments sending
    $(".new_comment").on("ajax:success", function(e, data, status, xhr) {
        flash_comment_result ('Коментар надіслано', 'succes');
        this.reset();
        remove_error_status(this);
        update_comment_list(xhr.responseText);
    }).on("ajax:error", function(e, xhr, status, error) {
        flash_comment_result('Коментар не надіслано', "error");
        remove_error_status(this);
        render_errors(xhr.responseText, this);
    });
    // end of comments sending

    // removing comments
    $(".comments_list_wrapper").on("click", function (e) {
        if(!e.target.classList.contains('remove_comment')) return;
        e.preventDefault();
        e.stopPropagation();
        confirm_removing(e.target)
    });
    // end of removing comments
}

// Helpers

function confirm_removing(remove_link) {
    var confirmation_modal = $('#delete_confirmation');
    confirmation_modal.off();
    confirmation_modal.show();
    confirmation_modal.on('click', function (e) {
        if(e.target.id === 'confirm_deletion') {
            var delete_request = remove_comment(remove_link);
            delete_request.done(function () {
                update_comment_list(delete_request.responseText)
            });
            confirmation_modal.hide();
        }
        else if (e.target.id === 'cencel_deletion') {
            confirmation_modal.hide();
        }
    });
}

function remove_comment(remove_link) {
    return $.ajax( { url: '/comments/' + remove_link.id, method: 'DELETE'} );
}


function update_comment_list(list_data) {
    $("ul.comments_list").remove();
    $(".comments_list_wrapper").prepend(list_data);
}

function flash_comment_result( text, class_name ) {
    var comment_result = $("#comment_result");
    comment_result.removeClass();
    comment_result.addClass(class_name);
    comment_result.finish();
    comment_result.empty();
    comment_result.show();
    comment_result.append(text).delay(5000).fadeOut(1000);
}


function render_errors(json, form) {
    var errors = JSON.parse(json);
    for (var key in errors) {
        if (errors.hasOwnProperty(key)) {
            var error_block = $(form).find('[name="comment[' + key +
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

