var React = require('react');
var ReactDOM = require('react-dom');
var mui = require("material-ui");
var Types = require("./DraggableTypes");
var DropTarget = require('react-dnd').DropTarget;

var orderedSiteObjectsTarget = {
  canDrop: function (props, monitor) {
    return true;
  },

  hover: function (props, monitor, component) {
    //
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

var OrderedSiteObjects = React.createClass({
  render: function () {
      var id = "ordered_objects";
      var connectDropTarget = this.props.connectDropTarget;

      return connectDropTarget(
        <div id="ordered_list" className='dd_list'>
          {this.props.children}
        </div>
      );
    }
});

module.exports = DropTarget(Types.SITEOBJECT, orderedSiteObjectsTarget, collect)(OrderedSiteObjects);
