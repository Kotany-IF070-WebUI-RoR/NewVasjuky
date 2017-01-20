if ($.cookie("theme_csspath")) {
    $('link#theme-stylesheet').attr("href", $.cookie("theme_csspath"));
}
if ($.cookie("theme_layout")) {
    $('body').addClass($.cookie("theme_layout"));
}

$(function () {

    menuSliding();
    animations();
    counters();

});

/* menu sliding */

function menuSliding() {


    $('.dropdown').on('show.bs.dropdown', function (e) {

  if ($(window).width() > 750) {
      $(this).find('.dropdown-menu').first().stop(true, true).slideDown();

  }
  else {
      $(this).find('.dropdown-menu').first().stop(true, true).show();
  }
    }

    );
    $('.dropdown').on('hide.bs.dropdown', function (e) {
  if ($(window).width() > 750) {
      $(this).find('.dropdown-menu').first().stop(true, true).slideUp();
  }
  else {
      $(this).find('.dropdown-menu').first().stop(true, true).hide();
  }
    });

}

/* animations */

function animations() {
    delayTime = 0;
    $('[data-animate]').css({opacity: '0'});
    $('[data-animate]').waypoint(function (direction) {
  delayTime += 150;
  $(this).delay(delayTime).queue(function (next) {
      $(this).toggleClass('animated');
      $(this).toggleClass($(this).data('animate'));
      delayTime = 0;
      next();
      //$(this).removeClass('animated');
      //$(this).toggleClass($(this).data('animate'));
  });
    },
      {
    offset: '90%',
    triggerOnce: true
      });

    $('[data-animate-hover]').hover(function () {
  $(this).css({opacity: 1});
  $(this).addClass('animated');
  $(this).removeClass($(this).data('animate'));
  $(this).addClass($(this).data('animate-hover'));
    }, function () {
  $(this).removeClass('animated');
  $(this).removeClass($(this).data('animate-hover'));
    });

}

function animationsSlider() {

    var delayTimeSlider = 400;

    $('.owl-item:not(.active) [data-animate-always]').each(function () {

  $(this).removeClass('animated');
  $(this).removeClass($(this).data('animate-always'));
  $(this).stop(true, true, true).css({opacity: 0});

    });

    $('.owl-item.active [data-animate-always]').each(function () {
  delayTimeSlider += 500;

  $(this).delay(delayTimeSlider).queue(function (next) {
      $(this).addClass('animated');
      $(this).addClass($(this).data('animate-always'));

      console.log($(this).data('animate-always'));

  });
    });



}

/* counters */

function counters() {

    $('.counter').counterUp({
  delay: 10,
  time: 1000
    });

}


/* picture zoom */

function pictureZoom() {

    $('.product .image, .post .image, .photostream div').each(function () {
  var imgHeight = $(this).find('img').height();
  $(this).height(imgHeight);
    });
}

function utils() {

    /* tooltips */

    $('[data-toggle="tooltip"]').tooltip();

    /* click on the box activates the radio */

    $('#checkout').on('click', '.box.shipping-method, .box.payment-method', function (e) {
  var radio = $(this).find(':radio');
  radio.prop('checked', true);
    });
    /* click on the box activates the link in it */

    $('.box.clickable').on('click', function (e) {

  window.location = $(this).find('a').attr('href');
    });
    /* external links in new window*/

    $('.external').on('click', function (e) {

  e.preventDefault();
  window.open($(this).attr("href"));
    });
    /* animated scrolling */

    $('.scroll-to, .scroll-to-top').click(function (event) {

  var full_url = this.href;
  var parts = full_url.split("#");
  if (parts.length > 1) {

      scrollTo(full_url);
      event.preventDefault();
  }
    });
    function scrollTo(full_url) {
  var parts = full_url.split("#");
  var trgt = parts[1];
  var target_offset = $("#" + trgt).offset();
  var target_top = target_offset.top - 100;
  if (target_top < 0) {
      target_top = 0;
  }

  $('html, body').animate({
      scrollTop: target_top
  }, 1000);
    }
}
