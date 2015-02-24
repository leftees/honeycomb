/** @jsx React.DOM */

var DRAG_THRESHOLD, Item, LEFT_BUTTON;

LEFT_BUTTON = 0;

DRAG_THRESHOLD = 3;

Item = React.createClass({
  getInitialState: function() {
    return {
      mouseDown: false,
      dragging: false
    };
  },
  style: function() {
    if (this.state.dragging) {
      return {
        position: 'fixed',
        left: this.state.left,
        top: this.state.top,
        zIndex: '1000',
      };
    } else {
      return {};
    }
  },
  onMouseDown: function(event) {
    var pageOffset;
    if (event.button === LEFT_BUTTON) {
      event.stopPropagation();
      event.preventDefault();
      this.addEvents();
      pageOffset = this.getDOMNode().getBoundingClientRect();
      return this.setState({
        mouseDown: true,
        viewportOriginX: event.pageX - document.body.scrollLeft,
        viewportOriginY: event.pageY - document.body.scrollTop,
        elementX: pageOffset.left,
        elementY: pageOffset.top
      });
    }
  },
  onMouseMove: function(event) {
    var deltaX, deltaY, distance;
    deltaX = (event.pageX - document.body.scrollLeft) - this.state.viewportOriginX;
    deltaY = (event.pageY - document.body.scrollTop) - this.state.viewportOriginY;
    distance = Math.abs(deltaX) + Math.abs(deltaY);
    if (!this.state.dragging && distance > DRAG_THRESHOLD) {
      this.setState({
        dragging: true
      });
      this.props.onDragStart(this.props.item, 'new_item');
    }
    if (this.state.dragging) {
      return this.setState({
        left: this.state.elementX + deltaX,
        top: this.state.elementY + deltaY
      });
    }
  },
  onMouseUp: function() {
    this.removeEvents();
    if (this.state.dragging) {
      this.props.onDragStop();
      return this.setState({
        dragging: false
      });
    }
  },
  addEvents: function() {
    document.addEventListener('mousemove', this.onMouseMove);
    return document.addEventListener('mouseup', this.onMouseUp);
  },
  removeEvents: function() {
    document.removeEventListener('mousemove', this.onMouseMove);
    return document.removeEventListener('mouseup', this.onMouseUp);
  },
  render: function() {
    var dragclass, honeypot_image;
    dragclass = "drag ";
    if (this.state.dragging) {
      dragclass = "" + dragclass + " dragging";
    }
    honeypot_image = this.props.item.links.image;
    return (
      <div className={dragclass} onMouseDown={this.onMouseDown} style={this.style()}>
        <HoneypotImage honeypot_image={honeypot_image} style="small" />
      </div>);
  }
});
