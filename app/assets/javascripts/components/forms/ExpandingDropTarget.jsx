var React = require('react');
var DropTarget = require('react-dnd').DropTarget;
var EventEmitter = require('../../EventEmitter');

/**
 * Specifies the drop target contract.
 * All methods are optional.
 */
const expandingDropTarget = {
  canDrop(props, monitor) {
    return true;
  },

  hover(props, monitor, component) {
    // This is fired very often and lets you perform side effects
    // in response to the hover. You can't handle enter and leave
    // here—if you need them, put monitor.isOver() into collect() so you
    // can just use componentWillReceiveProps() to handle enter/leave.

    // You can access the coordinates if you need them
    const clientOffset = monitor.getClientOffset();
    const componentRect = ReactDOM.findDOMNode(component).getBoundingClientRect();

    // You can check whether we're over a nested drop target
    const isJustOverThisOne = monitor.isOver({ shallow: true });

    // You will receive hover() even for items for which canDrop() is false
    const canDrop = monitor.canDrop();
  },

  drop(props, monitor, component) {
    if (monitor.didDrop()) {
      // If you want, you can check whether some nested
      // target already handled drop
      return;
    }

    // Obtain the dragged item
    const source = monitor.getItem();

    // Notify any listeners that this object received a drop event
    EventEmitter.emit("DNDSourceDroppedOnTarget", props.data, source)

    // You can also do nothing and return a drop result,
    // which will be available as monitor.getDropResult()
    // in the drag source's endDrag() method
    return { moved: true };
  }
};

/**
 * Specifies which props to inject into your component.
 */
function collect(connect, monitor) {
  return {
    // Call this function inside render()
    // to let React DnD handle the drag events:
    connectDropTarget: connect.dropTarget(),
    // You can ask the monitor about the current drag state:
    isOver: monitor.isOver(),
    isOverCurrent: monitor.isOver({ shallow: true }),
    canDrop: monitor.canDrop(),
    itemType: monitor.getItemType(),
  };
}

var ExpandingDropTarget = React.createClass({
  propTypes: {
    className: React.PropTypes.string.isRequired,
    targetClassName: React.PropTypes.string.isRequired,   // Class to use while the user is dragging a source to show that this is a target
    expandedClassName: React.PropTypes.string.isRequired, // Class to use while the user is hovering over with a source
    data: React.PropTypes.object.isRequired // Data that will be passed to the event listener when an event happens to this target
  },

  componentWillReceiveProps: function(nextProps) {
    if (!this.props.isOver && nextProps.isOver) {
      // You can use this as enter handler
    }

    if (this.props.isOver && !nextProps.isOver) {
      // You can use this as leave handler
    }

    if (this.props.isOverCurrent && !nextProps.isOverCurrent) {
      // You can be more specific and track enter/leave
      // shallowly, not including nested targets
    }
  },

  render: function() {
    // These props are injected by React DnD,
    // as defined by your `collect` function above:
    const { isOver, canDrop, connectDropTarget } = this.props;

    return connectDropTarget(
      <div>
        {!isOver && !canDrop && <div className={ this.props.className }></div>}
        {!isOver && canDrop && <div className={ this.props.targetClassName }/>}
        {isOver && canDrop && <div className={ this.props.expandedClassName }></div>}
        {this.props.children}
      </div>
    );
  }
})

module.exports = DropTarget("expanding_target", expandingDropTarget, collect)(ExpandingDropTarget);
