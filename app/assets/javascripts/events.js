function init_event_details() {
    $('section.events_list').on('click', function (event) {
        var target = $(event.target);
        if(target.is('button.event-detail-link')){
            var detail_url = Routes.event_url(+target.data('event-id'));
            $.ajax({
                url: detail_url,
                headers: {'HTTP_X_REQUESTED_WITH': 'XMLHttpRequest'},
                success: function (data, textStatus, request) {
                    prepareModal(data);
                    $('#event_details_modal').modal('toggle')
                },
                error: function (data) {
                    UnobtrusiveFlash.showFlashMessage('Упс... Щось пішло не так. ' +
                        'Перезавантажте сторінку',
                        {type: 'error'});
                }
            });
        }
    });

    // helpers

    function prepareModal(content) {
       $('.modal-body.event-detail').empty().append(content);
    }
}