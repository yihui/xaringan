(function() {
  "use strict"
  /* Move <script> tags from slides to end of document
   *
   * Runs after post-processing of markdown source into slides and moves only
   * <script>s on the last slide of continued slides using the .has-continuation
   * class added by xaringan. Finally, all <script>s in the slides area are
   * removed with a note that they can be found at the end of <body>.
   */
  var scripts = document.querySelectorAll(
    '.remark-slides-area .remark-slide-container:not(.has-continuation) script'
  );
  if (!scripts.length) return;
  for (var i = 0; i < scripts.length; i++) {
    var s = document.createElement('script');
    var code = document.createTextNode(scripts[i].textContent);
    s.appendChild(code);
    scripts[i].parentElement.replaceChild(s, scripts[i]);
  }
})();
