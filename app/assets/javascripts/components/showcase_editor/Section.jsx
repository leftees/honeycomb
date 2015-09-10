var React = require('react');
var Section = React.createClass({
  mixins: [DraggableMixin],

  propTypes: {
    section: React.PropTypes.object.isRequired,
    onSectionClick: React.PropTypes.func.isRequired
  },

  getInitialState: function() {
    return {
      hover: false,
    };
  },

  style: function() {
    return {
      border: '1px solid lightgrey',
      display: 'inline-block',
      verticalAlign: 'top',
      position: 'relative',
      marginLeft: '10px',
      marginRight: '10px',
      height: '100%',
    }
  },

  onDragStart: function() {
    this.props.onDragStart(this.props.section, 'reorder');
  },

  onDragStop: function() {
    this.props.onDragStop();
  },

  onMouseEnter: function() {
    return this.setState({
      hover: true
    });
  },

  onMouseLeave: function() {
    return this.setState({
      hover: false
    });
  },

  editSection: function() {
    this.props.onSectionClick(this.props.section);
  },

  render: function() {
    return (
      <div className="section cursor-grab" onMouseDown={this.onMouseDown} onMouseEnter={this.onMouseEnter} onMouseLeave={this.onMouseLeave} style={this.style()}>
        <SectionDragContent section={this.props.section} dragging={this.state.dragging} left={this.state.left} top={this.state.top} />
        <SectionImage section={this.props.section} />
        <SectionDescription section={this.props.section} />
        <EditLink clickHandler={this.editSection} visible={this.state.hover} />
      </div>
    );
  }
});
module.exports = Section;
