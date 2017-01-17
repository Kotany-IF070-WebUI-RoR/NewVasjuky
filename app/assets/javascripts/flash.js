$(function(){
        UnobtrusiveFlash.flashOptions['timeout'] = 2000; // milliseconds
        $('.unobtrusive-flash-container').click(function () {
            $(this).remove();
        });
    }
).ready();
