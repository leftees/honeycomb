var React = require('react');
var ReactDOM = require('react-dom');
var mui = require("material-ui");
var Types = require("./DraggableTypes");
var DropTarget = require('react-dnd').DropTarget;

var availableSiteObjectsTarget = {
  canDrop: function (props, monitor) {
    return true;
  },

  hover: function (props, monitor, component) {
    // var dragIndex = monitor.getItem().index;
    // var hoverIndex = props.index;
    // var clientOffset = monitor.getClientOffset();
    // var hoverBoundingRect = ReactDOM.findDOMNode(component).getBoundingClientRect();
    // var hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;
    // var hoverClientY = clientOffset.y - hoverBoundingRect.top;
  },

  drop: function (props, monitor, component) {
    //
  }
};

function collect(connect, monitor) {
  return {
    connectDropTarget: connect.dropTarget(),
  };
}

var AvailableSiteObjects = React.createClass({
  render: function () {
      var id = "ordered_objects";
      var connectDropTarget = this.props.connectDropTarget;

      return connectDropTarget(
        <div id="available_list" className='dd_list'>
          {this.props.children}
        </div>
      );
    }
});

module.exports = DropTarget(Types.SITEOBJECT, availableSiteObjectsTarget, collect)(AvailableSiteObjects);
