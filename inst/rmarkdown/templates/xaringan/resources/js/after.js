// delete the temporary CSS (for displaying all slides initially) when the user
// starts to view slides
(function() {
  var deleted = false;
  slideshow.on('beforeShowSlide', function(slide) {
    if (deleted) return;
    var sheets = document.styleSheets, node;
    for (var i = 0; i < sheets.length; i++) {
      node = sheets[i].ownerNode;
      if (node.dataset["target"] !== "print-only") continue;
      node.parentNode.removeChild(node);
    }
    deleted = true;
  });
})();
