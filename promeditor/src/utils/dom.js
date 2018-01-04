// Node.closest() polyfill
if (window.Element && !Element.prototype.closest) {
  Element.prototype.closest = function(s) {
    const matches = (this.document || this.ownerDocument).querySelectorAll(s);
    let el = this;
    let i;
    // eslint-disable-next-line
    do {
      i = matches.length;
      // eslint-disable-next-line
      while (--i >= 0 && matches.item(i) !== el) {}
    } while (i < 0 && (el = el.parentElement));
    return el;
  };
}

Element.prototype.previousCousin = function(s) {
  let sibling = this.parentElement.previousSibling;
  let el;
  while (sibling) {
    el = sibling.querySelector(s);
    if (el) {
      return el;
    }
    sibling = sibling.previousSibling;
  }
  return undefined;
};

export function getNextCharacter(global = window) {
  const selection = global.getSelection();
  if (!selection.anchorNode) {
    return null;
  }

  const range = selection.getRangeAt(0);
  const text = selection.anchorNode.textContent;
  const offset = range.startOffset;
  return text.substr(offset, 1);
}
