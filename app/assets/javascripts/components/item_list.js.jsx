/** @jsx React.DOM */

var ItemList;

ItemList = React.createClass({
  render: function() {
    var itemNodes, onDragStart, onDragStop, key;
    onDragStart = this.props.onDragStart;
    onDragStop = this.props.onDragStop;
    itemNodes = this.props.items.map(function(item, index) {
      key = "item-" + item.id
      return <Item  item={item} key={key} onDragStart={onDragStart} onDragStop={onDragStop} />
    });
    return (
      <div className="add-items-content-inner">
        <div className="add-items-title">
          <h2>Add Items</h2>
          <p>Click to Drag items into the exhibit</p>
        </div>
        {itemNodes}
      </div>);
  }
});
