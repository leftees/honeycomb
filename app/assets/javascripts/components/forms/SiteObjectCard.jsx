var React = require('react');
var ReactDOM = require('react-dom');
var update = require('react/lib/update');
var mui = require("material-ui");
var Types = require("./DraggableTypes");
var DragSource = require('react-dnd').DragSource;
var DropTarget = require('react-dnd').DropTarget;

var siteObjectSource = {
  beginDrag: function (props, monitor, component) {
    var site_object = {
      id: props.id,
      index: props.index
    };
    var hoverBoundingRect = ReactDOM.findDOMNode(component).getBoundingClientRect();
    var hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;
    var clientOffset = monitor.getClientOffset();
    return site_object;
  },

  endDrag: function (props, monitor, component) {
    var site_object = monitor.getItem();
  }
};

var siteObjectTarget = {
  hover: function (props, monitor, component) {
    var dragIndex = monitor.getItem().index;
    var hoverIndex = props.index;
    var clientOffset = monitor.getClientOffset();
    var hoverBoundingRect = ReactDOM.findDOMNode(component).getBoundingClientRect();
    var hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;
    var hoverClientY = clientOffset.y - hoverBoundingRect.top;
    // Dragging downwards
    if (hoverClientY < hoverMiddleY) {
      return;
    }

    // Dragging upwards
    if (hoverClientY > hoverMiddleY) {
      return;
    }

    component.props.moveCard(hoverIndex, props.site_object_list, dragIndex);
  },
}

function source_collect(connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  };
}

function target_collect(connect, monitor) {
  return {
    connectDropTarget: connect.dropTarget(),
  };
}

var SiteObjectCard = React.createClass({
  propTypes: {
    id: React.PropTypes.number.isRequired,
    index: React.PropTypes.number,
    site_object_name: React.PropTypes.string,
    connectDragSource: React.PropTypes.func,
    connectDropTarget: React.PropTypes.func,
    isDragging: React.PropTypes.bool,
    moveCard: React.PropTypes.func
  },

  render: function () {
    var id = this.props.id;
    var connectDragSource = this.props.connectDragSource;
    var connectDropTarget = this.props.connectDropTarget;
    var isDragging = this.props.isDragging;

    return connectDragSource(connectDropTarget(
      <div className="site_object_card">
        {this.props.site_object_name}
      </div>
    ));
  }
});

module.exports = DragSource(Types.SITEOBJECT, siteObjectSource, source_collect)(DropTarget(Types.SITEOBJECT, siteObjectTarget, target_collect)(SiteObjectCard));
