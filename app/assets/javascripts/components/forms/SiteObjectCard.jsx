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
      index: props.index,
      site_object: props.site_object,
      site_object_list: props.site_object_list
    };
    var hoverBoundingRect = ReactDOM.findDOMNode(component).getBoundingClientRect();
    var hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;
    var clientOffset = monitor.getClientOffset();
    return site_object;
  },

  endDrag: function (props, monitor, component) {
    var item = monitor.getItem();
    dropResult = monitor.getDropResult();
    if(dropResult && dropResult.source_list == dropResult.target_list){
      return;
    }
    component.props.removeCard(props.site_object_list, item.index, item.site_object);
  }
};

var siteObjectTarget = {
  // Called when a source gets dropped onto this target
  drop: function (props, monitor, component) {
    var sourceItem = monitor.getItem();
    var destIndex = props.index;
    var clientOffset = monitor.getClientOffset();
    var hoverBoundingRect = ReactDOM.findDOMNode(component).getBoundingClientRect();
    var hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;
    var hoverClientY = clientOffset.y - hoverBoundingRect.top;

    if (hoverClientY > hoverMiddleY) {
      destIndex++;
    }

    if(sourceItem.site_object_list == props.site_object_list) {
      component.props.moveCard(props.site_object_list, sourceItem.index, destIndex, sourceItem.site_object);
    } else {
      component.props.addCard(props.site_object_list, destIndex, sourceItem.site_object);
    }

    return { source_list: sourceItem.site_object_list, target_list: props.site_object_list }
  }
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
    addCard: React.PropTypes.func,
    moveCard: React.PropTypes.func,
    removeCard: React.PropTypes.func,
    site_object: React.PropTypes.object
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
