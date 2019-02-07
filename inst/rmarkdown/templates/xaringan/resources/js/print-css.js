(function(d) {
  var s = d.createElement("style"), r = d.querySelector(".remark-slide-scaler");
  if (!r) return;
  s.type = "text/css"; s.innerHTML = "@page {size: " + r.style.width + " " + r.style.height +"; }";
  d.head.appendChild(s);
})(document);

(function(d) {
  var el = d.getElementsByClassName("remark-slides-area");
  if (!el) return;
  var slide, slides = slideshow.getSlides(), els = el[0].children;
  for (var i = 1; i < slides.length; i++) {
    slide = slides[i];
    if (slide.properties.continued === "true" || slide.properties.count === "false") {
      els[i - 1].className += ' has-continuation';
    }
  }
  var s = d.createElement("style");
  s.type = "text/css"; s.innerHTML = "@media print { .has-continuation { display: none; } }";
  d.head.appendChild(s);
})(document);
