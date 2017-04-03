var c = setInterval(function(){}, 1000);
t_span = function() {
  var timerSpan = document.createElement('span');
  timerSpan.setAttribute('id', 'time-left');
  return timerSpan;
};
var timerSpan = t_span();
var temp = document.getElementsByClassName('remark-slide-number').item(1);
temp.appendChild(timerSpan);
time_format = function(time_left) {
  secs = Math.abs(time_left)/1000;
  var h = Math.floor(secs / 3600);
  var m = Math.floor((secs / 3600) %% 1 * 60);
  var s = Math.floor((secs / 60) %% 1 * 60);
  var res = s + 's ';
  if (m > 0) {
    res = m + 'm ' + res;
  }
  if (h > 0) {
    res = h + 'h ' + res;
  }
  return res;
};
slideshow.on('afterShowSlide', function (slide) {
  var time_left = %d;
  var counter_div = document.getElementsByClassName('remark-slide-number').item(slide.getSlideIndex());
  function counter() {
    return window.setInterval(function() {
      time_left = time_left - 1000;
      t = time_format(time_left);
      var span = document.getElementById('time-left');
      span.parentNode.removeChild(span);
      var timerSpan = t_span();
      if (time_left >= 0) {
        timerSpan.innerHTML = ' ' + t + ' Remaining';
      } else {
        timerSpan.innerHTML = ' ' + t + ' Over!';
        counter_div.style.color = 'red';
      }
      counter_div.appendChild(timerSpan);
    }, 1000);}
  clearInterval(c);
  c = counter();
});

