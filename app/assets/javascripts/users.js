function submit_rankings_period(select_period) {
    select_period.form.submit();
}
function init_user_ban_form() {
    $( 'body' ).on( 'click', '.ban', function( event ) {
        var user = event.target.getAttribute('data-user');
        var url = Routes.toggle_ban_account_admin_user_path(user);
        set_form_action(url);
        $('#user_ban_reason').val('');
        $('#ban_user').modal('show');
            });

    $( 'body' ).on( 'click', '.unban', function( event ) {
        var user = event.target.getAttribute('data-user');
        var url = Routes.toggle_ban_account_admin_user_path(user);
        var reason = event.target.getAttribute('data-reason');
        set_form_action(url);
        $('#ban_reason').text('Причина блокування: ' + reason);
        $('#unban_user').modal('show');
    });

    function set_form_action(url) {
        var form = $('.simple_form');
        form.attr('action', url)
    }


}