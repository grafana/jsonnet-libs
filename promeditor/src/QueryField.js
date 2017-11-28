import React from 'react';
import { Editor, Plain, Raw } from 'slate';
import Portal from 'react-portal';
import PluginEditCode from 'slate-edit-code';

// dom also includes Element polyfills
import { getNextCharacter } from './utils/dom';
import PluginPrism, { Prism } from './slate-plugins/prism/index';
import RunnerPlugin from './slate-plugins/runner';
import debounce from './utils/debounce';

import Typeahead from './Typeahead';
import './QueryField.css';

const BRACES = {
  '[': ']',
  '{': '}',
  '(': ')',
};
const RATE_RANGES = ['1m', '5m', '10m', '30m', '1h'];
const TYPEAHEAD_DEBOUNCE = 300;

function configurePrismMetricsTokens(metrics) {
  Prism.languages.promql.metric = {
    alias: 'variable',
    pattern: new RegExp(`\\b(${metrics.join('|')})\\b`, 'i'),
  };
}

function flattenSuggestions(s) {
  return s ? s.reduce((acc, g) => acc.concat(g.items), []) : [];
}

function processLabels(labels) {
  const values = {};
  labels.forEach(l => {
    const { __name__, ...rest } = l;
    Object.keys(rest).forEach(key => {
      if (!values[key]) values[key] = [];
      if (values[key].indexOf(rest[key]) === -1) values[key].push(rest[key]);
    });
  });
  return { values, keys: Object.keys(values) };
}

// Strip syntax chars
const cleanText = s => s.replace(/[{}[\]="(),!~+\-*/^%]/g, '').trim();

const getInitialState = query =>
  Raw.deserialize(
    {
      nodes: [
        {
          kind: 'block',
          type: 'paragraph',
          nodes: [
            {
              kind: 'text',
              text: query,
            },
          ],
        },
      ],
    },
    { terse: true }
  );

class QueryField extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.plugins = [RunnerPlugin(), PluginPrism(), PluginEditCode()];

    this.state = {
      labelKeys: {},
      labelValues: {},
      metrics: props.metrics || [],
      suggestions: [],
      state: getInitialState(props.initialQuery || ''),
      typeaheadIndex: 0,
      typeaheadPrefix: '',
    };
  }

  componentDidMount = () => {
    this.updateMenu();

    if (this.props.metrics === undefined) {
      this.fetchMetricNames();
    }
  };

  componentDidUpdate = () => {
    this.updateMenu();
  };

  componentWillReceiveProps(nextProps) {
    if (nextProps.metrics !== this.props.metrics) {
      this.setState({ metrics: nextProps.metrics }, this.onMetricsReceived);
    }
    // initialQuery is null in case the user typed
    if (
      nextProps.initialQuery !== null &&
      nextProps.initialQuery !== this.props.initialQuery
    ) {
      this.setState({ state: getInitialState(nextProps.initialQuery) });
    }
  }

  onChange = state => {
    this.setState({ state });

    window.requestAnimationFrame(this.handleTypeahead);
  };

  onDocumentChange = (doc, state) => {
    this.handleChangeQuery(state);
  };

  onMetricsReceived = () => {
    configurePrismMetricsTokens(this.state.metrics);
    // Trigger re-render
    window.requestAnimationFrame(() => {
      // Bogus edit to trigger highlighting
      const nextEditorState = this.state.state
        .transform()
        .insertText(' ')
        .deleteBackward(1)
        .apply();
      this.onChange(nextEditorState);
    });
  };

  request = url => {
    if (this.props.request) {
      return this.props.request(url);
    }
    return fetch(url);
  };

  handleChangeQuery = state => {
    // Send text change to parent
    const { onQueryChange } = this.props;
    if (onQueryChange) {
      onQueryChange(Plain.serialize(state));
    }
  };

  handleTypeahead = debounce(() => {
    const selection = window.getSelection();
    if (selection.anchorNode) {
      const wrapperNode = selection.anchorNode.parentNode;
      const editorNode = wrapperNode.closest('.query-field');
      if (!editorNode) {
        // Not inside an editor
        return;
      }

      const range = selection.getRangeAt(0);
      const text = selection.anchorNode.textContent;
      const offset = range.startOffset;
      const prefix = cleanText(text.substr(0, offset));

      // Determine candidates by context
      const suggestionGroups = [];
      const wrapperClasses = wrapperNode.classList;
      let typeaheadContext = null;

      // Take first metric as lucky guess
      const metricNode = editorNode.querySelector('.metric');

      if (wrapperClasses.contains('context-range')) {
        // Rate ranges
        typeaheadContext = 'context-range';
        suggestionGroups.push({
          label: 'Range vector',
          items: [...RATE_RANGES],
        });
      } else if (wrapperClasses.contains('context-labels') && metricNode) {
        const metric = metricNode.textContent;
        const labelKeys = this.state.labelKeys[metric];
        if (labelKeys) {
          if (
            (text && text.startsWith('=')) ||
            wrapperClasses.contains('attr-value')
          ) {
            // Label values
            const labelKeyNode = wrapperNode.previousCousin('.attr-name');
            if (labelKeyNode) {
              const labelKey = labelKeyNode.textContent;
              const labelValues = this.state.labelValues[metric][labelKey];
              typeaheadContext = 'context-label-values';
              suggestionGroups.push({
                label: 'Label values',
                items: labelValues,
              });
            }
          } else {
            // Label keys
            typeaheadContext = 'context-labels';
            suggestionGroups.push({ label: 'Labels', items: labelKeys });
          }
        } else {
          this.fetchMetricLabels(metric);
        }
      } else if (metricNode && wrapperClasses.contains('context-aggregation')) {
        typeaheadContext = 'context-aggregation';
        const metric = metricNode.textContent;
        const labelKeys = this.state.labelKeys[metric];
        if (labelKeys) {
          suggestionGroups.push({ label: 'Labels', items: labelKeys });
        } else {
          this.fetchMetricLabels(metric);
        }
      } else if (
        (this.state.metrics && (prefix || text.match(/[+\-*/^%]/))) ||
        wrapperClasses.contains('context-function')
      ) {
        // Need prefix for metrics
        typeaheadContext = 'context-metrics';
        suggestionGroups.push({
          label: 'Metrics',
          items: this.state.metrics,
        });
      }

      let results = 0;
      const filteredSuggestions = suggestionGroups.map(group => {
        if (group.items) {
          group.items = group.items.filter(
            c => c.length !== prefix.length && c.indexOf(prefix) > -1
          );
          results += group.items.length;
        }
        return group;
      });

      console.log(
        'handleTypeahead',
        selection.anchorNode,
        wrapperClasses,
        text,
        offset,
        prefix,
        typeaheadContext
      );

      this.setState({
        typeaheadPrefix: prefix,
        typeaheadContext,
        typeaheadText: text,
        suggestions: results > 0 ? filteredSuggestions : [],
      });
    }
  }, TYPEAHEAD_DEBOUNCE);

  applyTypeahead(state, suggestion) {
    const {
      typeaheadPrefix,
      typeaheadContext,
      typeaheadText,
    } = this.state;

    // Modify suggestion based on context
    switch (typeaheadContext) {
      case 'context-labels': {
        const nextChar = getNextCharacter();
        if (!nextChar || nextChar === '}' || nextChar === ',') {
          suggestion += '=';
        }
        break;
      }

      case 'context-label-values': {
        // Always add quotes and remove existing ones instead
        if (
          !(typeaheadText.startsWith('="') || typeaheadText.startsWith('"'))
        ) {
          suggestion = `"${suggestion}`;
        }
        if (getNextCharacter() !== '"') {
          suggestion = `${suggestion}"`;
        }
        break;
      }

      default: {
      }
    }

    this.resetTypeahead();

    // Remove the current, incomplete text and replace it with the selected suggestion
    let backward = typeaheadPrefix.length;
    const text = cleanText(typeaheadText);
    const suffixLength = text.length - typeaheadPrefix.length;
    const offset = typeaheadText.indexOf(typeaheadPrefix);
    const midWord =
      typeaheadPrefix &&
      ((suffixLength > 0 && offset > -1) || suggestion === typeaheadText);
    const forward = midWord ? suffixLength + offset : 0;
  
    return (
      state
        .transform()
        // TODO this line breaks if cursor was moved left and length is longer than whole prefix
        .deleteBackward(backward)
        .deleteForward(forward)
        .insertText(suggestion)
        .focus()
        .apply()
    );
  }

  onKeyDown = (event, data, state, editor) => {
    const { typeaheadIndex, suggestions } = this.state;

    switch (event.key) {
      case 'Tab': {
        // Dont blur input
        event.preventDefault();
        if (!suggestions || suggestions.length === 0 || !this.menu) {
          return;
        }
    
        // Get the currently selected suggestion
        const flattenedSuggestions = flattenSuggestions(suggestions);
        const selected = Math.abs(typeaheadIndex);
        const selectedIndex = selected % flattenedSuggestions.length || 0;
        const suggestion = flattenedSuggestions[selectedIndex];
    
        return this.applyTypeahead(state, suggestion);
      }

      case 'ArrowDown': {
        // Select next suggestion
        event.preventDefault();
        this.setState({ typeaheadIndex: typeaheadIndex + 1 });
        break;
      }

      case 'ArrowUp': {
        // Select previous suggestion
        event.preventDefault();
        this.setState({ typeaheadIndex: Math.max(0, typeaheadIndex - 1) });
        break;
      }

      case '{':
      case '[': {
        event.preventDefault();
        // Insert matching braces
        return state
          .transform()
          .insertText(`${event.key}${BRACES[event.key]}`)
          .move(-1)
          .focus()
          .apply();
      }

      case '(': {
        event.preventDefault();
        // Insert matching braces
        // HACK using 1024 as a long string end to move to
        return state
          .transform()
          .insertText(event.key)
          .move(1024)
          .insertText(BRACES[event.key])
          .move(-1025)
          .focus()
          .apply();
      }

      default: {
        // console.log('default key', event.key, event.which, event.charCode, event.locale, data.key);
        break;
      }
    }
  };

  resetTypeahead() {
    this.setState({
      suggestions: [],
      typeaheadIndex: 0,
      typeaheadPrefix: '',
      typeaheadContext: null,
    });
  }

  async fetchMetricLabels(name) {
    const url = `/api/v1/series?match[]=${name}`;
    try {
      const res = await this.request(url);
      const body = await res.json();
      const { keys, values } = processLabels(body.data);
      const labelKeys = {
        ...this.state.labelKeys,
        [name]: keys,
      };
      const labelValues = {
        ...this.state.labelValues,
        [name]: values,
      };
      this.setState({ labelKeys, labelValues }, this.handleTypeahead);
    } catch (e) {
      if (this.props.onRequestError) {
        this.props.onRequestError(e);
      } else {
        console.error(e);
      }
    }
  }

  async fetchMetricNames() {
    const url = '/api/v1/label/__name__/values';
    try {
      const res = await this.request(url);
      const body = await res.json();
      this.setState({ metrics: body.data }, this.onMetricsReceived);
    } catch (error) {
      if (this.props.onRequestError) {
        this.props.onRequestError(error);
      } else {
        console.error(error);
      }
    }
  }

  handleBlur = () => {
    const { onBlur } = this.props;
    if (onBlur) onBlur();
  };

  handleFocus = () => {
    const { onFocus } = this.props;
    if (onFocus) onFocus();
  };

  handleClickMenu = item => {
    const { state } = this.state;
    const nextState = this.applyTypeahead(state, item);

    // Internal state update
    this.onChange(nextState);
    // For some reason it's not a document change, manually sending state up
    this.handleChangeQuery(nextState);
  };

  handleOpen = portal => {
    this.menu = portal.firstChild;
  };

  handleClose = () => {
    delete this.menu;
  };

  updateMenu = () => {
    const { suggestions } = this.state;
    const menu = this.menu;
    const selection = window.getSelection();
    const node = selection.anchorNode;

    // No menu, nothing to do
    if (!menu) return;

    // No suggestions or blur, remove menu
    const hasSuggesstions = suggestions && suggestions.length > 0;
    if (!hasSuggesstions) {
      menu.removeAttribute('style');
      return;
    }

    // Align menu overlay to editor node
    if (node) {
      const rect = node.parentElement.getBoundingClientRect();
      menu.style.opacity = 1;
      menu.style.top = `${rect.top + window.scrollY + rect.height + 4}px`;
      menu.style.left = `${rect.left + window.scrollX - 2}px`;
    }
  };

  renderMenu = () => {
    const { suggestions } = this.state;
    const hasSuggesstions = suggestions && suggestions.length > 0;
    if (!hasSuggesstions) return null;

    // Guard selectedIndex to be within the length of the suggestions
    let selectedIndex = Math.max(this.state.typeaheadIndex, 0);
    const flattenedSuggestions = flattenSuggestions(suggestions);
    selectedIndex = selectedIndex % flattenedSuggestions.length || 0;
    const selectedKeys =
      flattenedSuggestions.length > 0
        ? [flattenedSuggestions[selectedIndex]]
        : [];

    return (
      <Portal
        isOpened
        closeOnEsc
        closeOnOutsideClick
        onOpen={this.handleOpen}
        onClose={this.handleClose}
      >
        <Typeahead
          selectedItems={selectedKeys}
          onClickItem={this.handleClickMenu}
          groupedItems={suggestions}
        />
      </Portal>
    );
  };

  render = () => {
    return (
      <div className="query-field">
        {this.renderMenu()}
        <Editor
          autoCorrect={false}
          placeholder={this.props.placeholder}
          placeholderClassName="query-field__placeholder"
          plugins={this.plugins}
          state={this.state.state}
          onBlur={this.handleBlur}
          onKeyDown={this.onKeyDown}
          onChange={this.onChange}
          onDocumentChange={this.onDocumentChange}
          onFocus={this.handleFocus}
          onPressEnter={this.props.onPressEnter}
          spellCheck={false}
        />
      </div>
    );
  };
}

export default QueryField;
