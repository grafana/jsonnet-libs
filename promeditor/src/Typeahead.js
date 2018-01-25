import React from 'react';

import './Typeahead.css';

const TypeaheadItem = ({ isSelected, label, onClickItem }) => {
  const className = isSelected
    ? 'typeahead-item typeahead-item__selected'
    : 'typeahead-item';
  const onClick = () => onClickItem(label);
  return (
    <li className={className} onClick={onClick}>
      {label}
    </li>
  );
};

const TypeaheadGroup = ({ items, label, selected, onClickItem }) => (
  <li className="typeahead-group">
    <div className="typeahead-group__title">{label}</div>
    <ul className="typeahead-group__list">
      {items.map(item => (
        <TypeaheadItem
          key={item}
          onClickItem={onClickItem}
          isSelected={selected.indexOf(item) > -1}
          label={item}
        />
      ))}
    </ul>
  </li>
);

class Typeahead extends React.PureComponent {
  render() {
    const { groupedItems, menuRef, selectedItems, onClickItem } = this.props;
    return (
      <ul className="typeahead" ref={menuRef}>
        {groupedItems.map(g => (
          <TypeaheadGroup
            key={g.label}
            onClickItem={onClickItem}
            selected={selectedItems}
            {...g}
          />
        ))}
      </ul>
    );
  }
}

export default Typeahead;
