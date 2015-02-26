/** @jsx React.DOM */

var Item = React.createClass({
  mixins: [DraggableMixin],
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

  onDragStart: function() {
    this.props.onDragStart(this.props.item, 'new_item');
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
