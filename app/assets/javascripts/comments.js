"use strict";
function init_comments_page() {
    // Comments sending
    $(".new_comment").on("ajax:success", function (e, data, status, xhr) {
        UnobtrusiveFlash.showFlashMessage('Коментар надіслано',
            {type: 'success'});
        this.reset();
        remove_error_status(this);
        $('div.comment-list').prepend(xhr.responseText);
    }).on("ajax:error", function (e, xhr, status, error) {
        UnobtrusiveFlash.showFlashMessage('Коментар не надіслано',
            {type: 'error'});
        remove_error_status(this);
        render_errors(xhr.responseText, this, 'comment');
    });
    // end of comments sending

    // removing comments
    $(".comment-list-wrapper").on("click", function (e) {
        var target = e.target,
            target_parent = target.parentNode,
            remove_link;
        if (target.classList.contains('remove-comment') ||
            target_parent.classList.contains('remove-comment')) {
            e.preventDefault();
            e.stopPropagation();
            remove_link = (target.id.trim() !== '') ? target : target_parent;
            confirm_removing(remove_link);
        }
    });
    // end of removing comments
    init_infinity_scroll(1, comments_source_url(), false);

    // Helpers

    function comments_source_url() {
        var location = window.location;
        var source = location.protocol + '//' + location.host +
            location.pathname + '/comments'
        return source
    }

    function confirm_removing(remove_link) {
        var confirmation_modal = $('#delete_confirmation');
        confirmation_modal.off();
        confirmation_modal.show();
        confirmation_modal.on('click', function (e) {
            if (e.target.id === 'confirm_deletion') {
                var delete_request = remove_comment(remove_link);
                delete_request.done(function () {
                    $(remove_link).parents('div.comment').remove()
                });
                confirmation_modal.hide();
                UnobtrusiveFlash.showFlashMessage('Коментар видалено',
                    {type: 'warning'});
            }
            else if (e.target.id === 'cencel_deletion') {
                confirmation_modal.hide();
            }
        });
    }

    function remove_comment(remove_link) {
        return $.ajax({url: Routes.comment_path(remove_link.id) , method: 'DELETE'});
    }
}


