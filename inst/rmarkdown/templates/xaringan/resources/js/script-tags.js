(function() {
  "use strict"
  // Replace <script> tags in slides area to make them executable
  var scripts = document.querySelectorAll(
    '.remark-slides-area .remark-slide-container script'
  );
  if (!scripts.length) return;
  for (var i = 0; i < scripts.length; i++) {
    var s = document.createElement('script');
    var code = document.createTextNode(scripts[i].textContent);
    s.appendChild(code);
    var scriptAttrs = scripts[i].attributes;
    for (var j = 0; j < scriptAttrs.length; j++) {
      s.setAttribute(scriptAttrs[j].name, scriptAttrs[j].value);
    }
    scripts[i].parentElement.replaceChild(s, scripts[i]);
  }
})();
