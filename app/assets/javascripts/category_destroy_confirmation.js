function modalWindow() {
  var destroyButton = Array.from($('.glyphicon.glyphicon-trash'));

  destroyButton.forEach(function (destroyButton) {
    destroyButton.addEventListener('click', function () {
      setTimeout(function() {
        if ($(window).width() > 767) {
          var popover = Array.from($('.popover.fade.right.in'));

          popover.forEach(function (popover) {
            popover.className = 'popover fade bottom in';
          });
        }

        var buttonYes = Array.from($('.btn.btn-danger')),
        buttonNo = Array.from($('.btn.btn-small'));

        buttonYes.forEach(function (buttonYes) {
          buttonYes.innerHTML = 'Так';
        });

        buttonNo.forEach(function (buttonNo) {
          buttonNo.innerHTML = 'Ні';
        });
      }, 1);
    });
  });
}

$(window).load(modalWindow);
