/** @jsx React.DOM */

var Item = React.createClass({
  mixins: [DraggableMixin],

  style: function() {
    return {
      border: 'solid',
      borderRadius: '10px',
      fontWeight: 'bold',
      fontSize: '24px',
      color: 'rgba(0, 0, 0, 0.2)',
      marginLeft: '5px',
      marginRight: '5px',
      overflow: 'hidden',
    };
  },

  onDragStart: function() {
    this.props.onDragStart(this.props.item, 'new_item');
  },

  onDragStop: function() {
    this.props.onDragStop();
  },

  render: function() {
    var honeypot_image = this.props.item.links.image;
    var dragContent = (
      <HoneypotImage honeypot_image={honeypot_image} style="small" />
    );
    return (
      <div className='cursor-grab' onMouseDown={this.onMouseDown} style={this.style()}>
        <DragContent content={dragContent} dragging={this.state.dragging} left={this.state.left} top={this.state.top} />
        <HoneypotImage honeypot_image={honeypot_image} style="small" />
      </div>);
  }
});
