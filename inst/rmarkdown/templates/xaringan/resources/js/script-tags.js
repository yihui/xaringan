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
  document.body.appendChild(
    document.createComment('scripts moved from inside remark slide source')
  );
  for (var i = 0; i < scripts.length; i++) {
    var s = document.createElement('script');
    var code = document.createTextNode(scripts[i].textContent);
    s.appendChild(code);
    document.body.appendChild(s);
  }
  var all_scripts = document.querySelectorAll('.remark-slides-area script');
  for (var i = 0; i < all_scripts.length; i++) {
    // remove original <script> tags and leave a note
    var note = document.createComment('script moved to end of document body by xaringan');
    all_scripts[i].parentElement.replaceChild(note, all_scripts[i]);
  }
})();
