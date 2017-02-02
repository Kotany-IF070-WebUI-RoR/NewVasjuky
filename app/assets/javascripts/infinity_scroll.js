"use strict";
function init_infinity_scroll(initial_page_number, request_url, load_first_page) {
    var page_number;
    if (initial_page_number === undefined) {
        page_number = 1;
    }
    else {
        page_number = initial_page_number
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
            success: function (data) {
                if (data !== 'end_of_list') {
                    $('.loaded_data_container').append(data);
                    start_infinity_scroll();
                    page_number++;
                }
            },
            error: function (data) {
                UnobtrusiveFlash.showFlashMessage('Упс... Щось пішло не так. ' +
                    'Перезавантажте сторінку',
                    {type: 'error'});
                console.log(data)
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
        return url + page_parameter_definition + page_number;
    }
}


