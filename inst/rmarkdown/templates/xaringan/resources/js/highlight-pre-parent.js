// adds .remark-code-has-line-highlighted class to <pre> parent elements
// of code chunks containing highlighted lines with class .remark-code-line-highlighted
(function(d) {
  const hlines = d.querySelectorAll('.remark-code-line-highlighted');
  const preParents = [];
  const findPreParent = function(line, p = 0) {
    if (p > 1) return null; // traverse up no further than grandparent
    const el = line.parentElement;
    return el.tagName === "PRE" ? el : findPreParent(el, ++p);
  };

  for (let line of hlines) {
    let pre = findPreParent(line);
    if (pre && !preParents.includes(pre)) preParents.push(pre);
  }
  preParents.forEach(p => p.classList.add("remark-code-has-line-highlighted"));
})(document);
