function(time) {
  var d2 = function(number) {
    return ('0' + number).slice(-2); // left-pad 0 to minutes/seconds
  },

  time_format = function(total) {
    var secs = Math.abs(total) / 1000;
    var h = Math.floor(secs / 3600);
    var m = Math.floor(secs % 3600 / 60);
    var s = Math.round(secs % 60);
    var res = d2(m) + ':' + d2(s);
    if (h > 0) res = h + ':' + res;
    return res;  // [hh:]mm:ss
  },

  slide_number_div = function(i) {
    return document.getElementsByClassName('remark-slide-number').item(i);
  },

  current_page_number = function(i) {
    return slide_number_div(i).firstChild.textContent;  // text "i / N"
  };

  var timer = document.createElement('span'); timer.id = 'slide-time-left';
  var time_left = time, k = slideshow.getCurrentSlideIndex(),
      last_page_number = current_page_number(k);

  setInterval(function() {
    time_left = time_left - 1000;
    timer.innerHTML = ' ' + time_format(time_left);
    if (time_left < 0) timer.style.color = 'red';
  }, 1000);

  slide_number_div(k).appendChild(timer);

  slideshow.on('showSlide', function(slide) {
    var i = slide.getSlideIndex(), n = current_page_number(i);
    // reset timer when a new slide is shown and the page number is changed
    if (last_page_number !== n) {
      time_left = time; last_page_number = n;
      timer.innerHTML = ' ' + time_format(time); timer.style.color = null;
    }
    slide_number_div(i).appendChild(timer);
  });
}
