/** @jsx React.DOM */

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

  outerStyle: function() {
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

  style: function() {
    return this.draggableStyle();
  },

  editStyle: function() {
    var styles = {
      color: 'white',
      position: 'absolute',
      display: 'block',
      bottom: 0,
      left: 0,
      background: 'rgba(0, 0, 0, 0.8)',
      width: '100%',
      padding: '8px',
      textAlign: 'center',
      cursor: 'pointer',
    }
    if (!this.state.hover) {
      styles.visibility = 'hidden';
    }
    return styles;
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

  handleClick: function(e) {
    e.preventDefault();
    this.props.onSectionClick(this.props.section);
  },

  render: function() {
    return (
      <div className="section cursor-grab" onMouseDown={this.onMouseDown} onMouseEnter={this.onMouseEnter} onMouseLeave={this.onMouseLeave} style={this.outerStyle()}>
        <SectionDragContent section={this.props.section} dragging={this.state.dragging} left={this.state.left} top={this.state.top} />
        <SectionImage section={this.props.section} />
        <SectionDescription section={this.props.section} />
        <div className="section-edit" onClick={this.handleClick} style={this.editStyle()}>Edit</div>
      </div>
    );
  }
});
