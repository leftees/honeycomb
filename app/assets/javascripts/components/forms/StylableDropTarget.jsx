// Extension of DnD DropTarget. Allows three custom styles based on the state of
// DnD, ex: one style can be used when the user is dragging a source and a different
// style can be used when a source is hovering over this target.
//
var React = require('react');
var DropTarget = require('react-dnd').DropTarget;

const stylableDropTarget = {
  canDrop(props, monitor) {
    return true;
  },

  drop(props, monitor, component) {
    if (monitor.didDrop()) {
      return;
    }
    return props.data;
  }
};

function collect(connect, monitor) {
  return {
    connectDropTarget: connect.dropTarget(),
    isOver: monitor.isOver(),
    isOverCurrent: monitor.isOver({ shallow: true }),
    canDrop: monitor.canDrop(),
    itemType: monitor.getItemType(),
  };
}

var StylableDropTarget = React.createClass({
  propTypes: {
    className: React.PropTypes.string.isRequired,
    dragClassName: React.PropTypes.string.isRequired,   // Class to use while the user is dragging a source to show that this is a target
    hoverClassName: React.PropTypes.string.isRequired, // Class to use while the user is hovering over with a source
    data: React.PropTypes.object.isRequired // Data that will be passed when a drop event happens to this target (via monitor.getDropResult())
  },

  render: function() {
    const { isOver, canDrop, connectDropTarget } = this.props;

    return connectDropTarget(
      <div>
        {!isOver && !canDrop && <div className={ this.props.className }></div>}
        {!isOver && canDrop && <div className={ this.props.dragClassName }/>}
        {isOver && canDrop && <div className={ this.props.hoverClassName }></div>}
        {this.props.children}
      </div>
    );
  }
})

function Instantiate(type) {
  return DropTarget(type, stylableDropTarget, collect)(StylableDropTarget);
}

module.exports = Instantiate;
