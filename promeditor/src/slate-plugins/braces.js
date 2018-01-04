const BRACES = {
  '[': ']',
  '{': '}',
  '(': ')',
};

export default function BracesPlugin() {
  return {
    onKeyDown(event, change) {
      const { value } = change;
      if (!value.isCollapsed) {
        return undefined;
      }

      switch (event.key) {
        case '{':
        case '[': {
          event.preventDefault();
          // Insert matching braces
          change
            .insertText(`${event.key}${BRACES[event.key]}`)
            .move(-1)
            .focus();
          return true;
        }

        case '(': {
          event.preventDefault();
          const length = value.anchorText.text.length;
          const offset = value.anchorOffset;
          const forward = length - offset;
          // Insert matching braces
          change
            .insertText(event.key)
            .move(forward)
            .insertText(BRACES[event.key])
            .move(-1 - forward)
            .focus();
          return true;
        }

        default: {
          break;
        }
      }
    },
  };
}
