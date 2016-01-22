var React = require('react');
var ReactDOM = require('react-dom');
var update = require('react/lib/update');
var mui = require("material-ui");
var Types = require("./DraggableTypes");
var DragSource = require('react-dnd').DragSource;
var EventEmitter = require('../../EventEmitter');

var siteObjectSource = {
  beginDrag: function (props, monitor, component) {
    return props;
  },

  endDrag: function (props, monitor, component) {
    var item = monitor.getItem();
    dropResult = monitor.getDropResult();

    if(!monitor.didDrop()){
      EventEmitter.emit("DNDSourceDroppedOnNothing", item);
    }
  }
};

function source_collect(connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    connectDragPreview: connect.dragPreview(),
    isDragging: monitor.isDragging()
  };
}

var SiteObjectCard = React.createClass({
  propTypes: {
    id: React.PropTypes.number.isRequired,
    index: React.PropTypes.number,
    site_object: React.PropTypes.object
  },

  getInitialState: function() {
    return {
      name: this.props.site_object.object.name || this.props.site_object.object.name_line_1,
    };
  },

  getText: function() {
    return this.props.site_object.object.name || this.props.site_object.object.name_line_1;
  },

  getAvatar: function() {
    var object = this.props.site_object.object;
    if(object.image)
      return (<mui.Avatar src={ object.image['thumbnail\/small'].contentUrl } />);
    else {
      var letter = this.props.site_object.type.substring(0, 1);
      return (<mui.Avatar style={{color: 'red'}}>{ letter }</mui.Avatar>);
    }
  },

  getDragAvatar: function() {
    const { connectDragSource } = this.props;
    return connectDragSource(<div>{ this.getAvatar() }</div>);
  },

  removeCard: function(){
    EventEmitter.emit("SiteObjectCard#Remove", this.props);
  },

  render: function () {
    const { connectDragSource, connectDragPreview, isDragging } = this.props;
    return connectDragSource(
      <div>
        <mui.Card style={{ cursor: "move" }}>
          <mui.CardHeader title={ this.getText() }  avatar={ this.getAvatar() } />
        </mui.Card>
      </div>
    );
  }
});

module.exports = DragSource("expanding_target", siteObjectSource, source_collect)(SiteObjectCard);
