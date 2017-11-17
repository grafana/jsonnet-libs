// Call this.props.onPressEnter, or enter soft new line when shift is pressed
export default () => ({
  onKeyDown: (e, data, state, editor) => {
    // Handle enter
    if (data.key === 'enter') {
      if (e.shiftKey && !e.altKey) {
        // Soft new line
        const transform = state.transform()
        if (state.isExpanded) transform.delete()
        transform.insertText('\n')
        return transform.apply();
      } else {
        // Submit on Enter
        const { onPressEnter } = editor.props;
        if (onPressEnter) {
          e.preventDefault();
          onPressEnter(e);
        }
      }
      return state;
    }
  }
});
