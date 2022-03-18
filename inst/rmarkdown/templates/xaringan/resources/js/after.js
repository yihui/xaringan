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
// add `data-at-shortcutkeys` attribute to <body> to resolve conflicts with JAWS
// screen reader (see PR #262)
(function(d) {
  let res = {};
  d.querySelectorAll('.remark-help-content table tr').forEach(tr => {
    const t = tr.querySelector('td:nth-child(2)').innerText;
    tr.querySelectorAll('td:first-child .key').forEach(key => {
      const k = key.innerText;
      if (/^[a-z]$/.test(k)) res[k] = t;  // must be a single letter (key)
    });
  });
  d.body.setAttribute('data-at-shortcutkeys', JSON.stringify(res));
})(document);
