(function() {
  "use strict"
  /* Replace <script> tags in slides area to make them executable
   *
   * Runs after post-processing of markdown source into slides and replaces only
   * <script>s on the last slide of continued slides using the .has-continuation
   * class added by xaringan. Finally, any <script>s in the slides area that
   * aren't executed are commented out.
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
  var scriptsNotExecuted = document.querySelectorAll(
    '.remark-slides-area .remark-slide-container.has-continuation script'
  );
  if (!scriptsNotExecuted.length) return;
  for (var i = 0; i < scriptsNotExecuted.length; i++) {
    var comment = document.createComment(scriptsNotExecuted[i].outerHTML)
    scriptsNotExecuted[i].parentElement.replaceChild(comment, scriptsNotExecuted[i])
  }
})();
