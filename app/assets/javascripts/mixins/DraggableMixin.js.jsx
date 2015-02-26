/** @jsx React.DOM */
var LEFT_BUTTON = 0;
var DRAG_THRESHOLD = 3;

var DraggableMixin = {
  getInitialState: function() {
    return {
      mouseDown: false,
      dragging: false,
    };
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
  onMouseUp: function() {
    this.removeEvents();
    if (this.state.dragging) {
      this.props.onDragStop();
      return this.setState({
        dragging: false
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
      if (this.onDragStart) {
        this.onDragStart();
      }
    }
    if (this.state.dragging) {
      return this.setState({
        left: this.state.elementX + deltaX,
        top: this.state.elementY + deltaY
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
};
