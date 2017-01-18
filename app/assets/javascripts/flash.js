$(function(){
        UnobtrusiveFlash.flashOptions['timeout'] = 3000; // milliseconds
        $('.unobtrusive-flash-container').click(function () {
            $(this).remove();
        });
    }
).ready();
