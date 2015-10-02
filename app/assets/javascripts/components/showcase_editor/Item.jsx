var React = require('react');
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
      display: 'inline-block',
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
    if (honeypot_image == null) {
      return null;
    }
    var dragContent = (
      <HoneypotImage honeypot_image={honeypot_image} style="small" cssStyle={{height: '100px', margin: '5px'}} title={this.props.item.name} />
    );
    return (
      <div className='cursor-grab' onMouseDown={this.onMouseDown} style={this.style()}>
        <DragContent content={dragContent} dragging={this.state.dragging} left={this.state.left} top={this.state.top} />
        <HoneypotImage honeypot_image={honeypot_image} style="small" cssStyle={{height: '100px', margin: '5px'}} title={this.props.item.name} />
      </div>
    );
  }
});
module.exports = Item;
