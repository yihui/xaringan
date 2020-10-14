function(data, token) {
  // data is an object of the form { path: base64 data }; we need to move base64
  // data back to HTML nodes (e.g., into the 'src' attribute of <img>)
  var i, s, d, el, els;
  els = document.querySelectorAll('img[src^="' + token + '"]');
  for (i = 0; i < els.length; i++) {
    el = els[i]; s = el.src.replace(token, ''); d = data[s];
    if (d) el.src = d;
  }
  els = document.querySelectorAll('div.remark-slide-content[style]');
  for (i = 0; i < els.length; i++) {
    el = els[i]; s = el.style.backgroundImage; if (!s) continue;
    s = s.match(/^url\("?(.+?)"?\)$/); if (!s || s.length < 2) continue;
    s = s[1].replace(token, ''); d = data[s];
    if (d) el.style.backgroundImage = 'url("' + d + '")';
  }
}
