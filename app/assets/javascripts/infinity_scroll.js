"use strict";
function init_infinity_scroll(initial_page_number, request_url, load_first_page) {
    var current_page;
    if (initial_page_number === undefined) {
        current_page = 1;
    }
    else {
        current_page = initial_page_number
    }
    if (load_first_page === true) load_data();
    start_infinity_scroll();

    function start_infinity_scroll() {
        $(window).on('scroll', function () {
            if (end_of_page()) {
                load_data();
                $(window).off('scroll');
            }
        });
    }

    function end_of_page() {
        return $(window).scrollTop() + $(window).height() > $(document).height() - 100
    }

    function load_data() {
        $.ajax({
            url: get_request_url(),
            headers: {'HTTP_X_REQUESTED_WITH': 'XMLHttpRequest'},
            success: function (data, textStatus, request) {
                var total_pages = +request.getResponseHeader('TotalPages');
                $('.loaded_data_container').append(data);
                if (current_page < total_pages) {
                    start_infinity_scroll();
                    current_page++;
                }
            },
            error: function (data) {
                UnobtrusiveFlash.showFlashMessage('Упс... Щось пішло не так. ' +
                    'Перезавантажте сторінку',
                    {type: 'error'});
            },
            beforeSend: function () {
                $('#loader-block').toggleClass('hidden');
            },
            complete: function () {
                $('#loader-block').toggleClass('hidden');
            }
        });
    }


    function get_request_url() {
        var url = request_url, page_parameter_definition;
        if (url.indexOf('?') === -1) {
            page_parameter_definition = '?page=';
        }
        else {
            page_parameter_definition = '&page=';
        }
        return url + page_parameter_definition + current_page;
    }
}


