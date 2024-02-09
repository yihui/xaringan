((interval, path) => {
const ws = new WebSocket(location.href.replace(/^http/, 'ws').replace(/\/?$/, '/websocket/'));
let flag, focused = false;

window.addEventListener('focus', e => { focused = true; });
window.addEventListener('blur',  e => { focused = false; });

ws.onmessage = event => {
  flag = true;
  const d = JSON.parse(event.data);
  if (d === true) {
    // fire a servr:reload event
    Event && document.dispatchEvent(new Event('servr:reload'));
    return location.reload();
  }
  if (!window.slideshow || !window.remark || d === false || d === null) return;
  let p = d.page; if (p < 1) p = 1;
  if (!focused) slideshow.gotoSlide(p);
  if (d.markdown === false) return;
  let el = document.getElementsByClassName('remark-slides-area');
  el = el[0].children[p - 1].querySelector('.remark-slide-content');
  const n = el.querySelector('.remark-slide-number').outerHTML.toString();
  el.innerHTML = remark.convert(d.markdown) + n;
  if (window.MathJax) {
    slideshow._releaseMath(el);
    MathJax.Hub.Queue(['Typeset', MathJax.Hub, el]);
  }
  [...el.getElementsByTagName('pre')].forEach(code => {
    if (code.querySelector('.\\.hidden')) {
      code.style.display = 'none'; return;
    }
    remark.highlighter.engine.highlightBlock(code);
  });
};

// send the page number to R, so RStudio can move to the Rmd source of the
// current slide
setInterval(() => {
  if (flag === false || ws.readyState !== ws.OPEN) return;
  flag = false;
  ws.send((window.slideshow && window.remark) ? JSON.stringify({
    'n': slideshow.getCurrentSlideIndex() + 1,
    'N': slideshow.getSlideCount(),
    'focused': focused
  }) : '{}');
}, interval);
})
