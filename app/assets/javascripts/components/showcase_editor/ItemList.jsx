/** @jsx React.DOM */
var React = require('react');
var ItemList = React.createClass({
  style: function() {
    return {
      whiteSpace: 'nowrap',
      width: '100%',
      border: '1px solid #bed5cd',
      overflowX: 'scroll',
      overflowY: 'hidden',
      padding: '14px',
    };
  },

  titleStyle: function() {
    return {
      display: 'inline-block',
      marginRight: '5px',
      verticalAlign: 'top',
    };
  },

  render: function() {
    var itemNodes, onDragStart, onDragStop, key;
    onDragStart = this.props.onDragStart;
    onDragStop = this.props.onDragStop;
    itemNodes = this.props.items.map(function(item, index) {
      key = "item-" + item.id
      return <Item item={item} key={key} onDragStart={onDragStart} onDragStop={onDragStop} />
    });
    return (
      <div className="add-items-content-inner" style={this.style()}>
        <div className="add-items-title" style={this.titleStyle()}>
          <h2>Add Items</h2>
          <p>Click to Drag items into the exhibit</p>
        </div>
        {itemNodes}
      </div>);
  }
});
module.exports = ItemList;
