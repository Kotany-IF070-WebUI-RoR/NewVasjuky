"use strict";
function validate_attachment() {
    $('#issue_attachment').bind('change', function () {
        var size_in_megabytes = this.files[0].size / 1024 / 1024;
        var file_extension = ['jpeg', 'jpg', 'png'];
        var error_messages = [];
        if (size_in_megabytes > 10) {
            error_messages.push('Розмір фото повиннен бути менше 5Mб. Будь-ласка виберіть фото меншого розміру.');
        }
        if ($.inArray(this.value.split('.').pop().toLowerCase(), file_extension) === -1) {
            error_messages.push("Дозволені тільки вказані формати: " + file_extension.join(', '));
        }
        if (error_messages.length > 0) {
            UnobtrusiveFlash.showFlashMessage(error_messages.join(' '), {type: 'error', timeout: 0});
            this.value = '';
        }
    });

