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
        render_errors(xhr.responseText, this);
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


    // comments autoload
    var comment_page = 1;
    load_comments();
    // end of comments autoload

    // Helpers

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
        return $.ajax({url: '/comments/' + remove_link.id, method: 'DELETE'});
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

    function end_of_page() {
        return $(window).scrollTop() + $(window).height() > $(document).height() - 100
    }

    function load_comments() {
        var url = window.location.href;
        var request = $.ajax({ url: url + '/comments?page=' + comment_page,
            headers: {'HTTP_X_REQUESTED_WITH': 'XMLHttpRequest'},
            method: 'GET', cache: false });
        $('#loader-block').toggleClass('hidden');
        request.success(function(data){
            $('.comment-list').append(data);
            start_scroll_listening();
            comment_page++;
            $('#loader-block').toggleClass('hidden');
        });

        request.fail(function (response) {
            if (response.responseText !== "end_of_comments_list") {
                UnobtrusiveFlash.showFlashMessage('Ми не змогли ' +
                    'завантажити коментарі, перезавантажте сторінку',
                    {type: 'error'});
            }
            $('#loader-block').toggleClass('hidden');
        })
    }

    function start_scroll_listening() {
        $(window).on('scroll', function () {
            if (end_of_page()) {
                load_comments();
                $(window).off('scroll');
            }
        });
    }
}


