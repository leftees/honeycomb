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
    var dragContent;
    if (this.props.section.image) {
      dragContent = (<img src={this.props.section.image} className="small-image-dragging" />);
    } else {
      gibberishTextString = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages.";

      dragContent = (<div className="small-text-dragging"><h4>{this.props.section.title}</h4><p>{gibberishTextString}</p></div>);
    }
    return (
      <div className="section" onMouseDown={this.onMouseDown} onMouseEnter={this.onMouseEnter} onMouseLeave={this.onMouseLeave} style={this.outerStyle()}>
        <DragContent content={dragContent} dragging={this.state.dragging} left={this.state.left} top={this.state.top} />
        <SectionImage section={this.props.section} />
        <SectionDescription section={this.props.section} />
        <div className="section-edit" onClick={this.handleClick} style={this.editStyle()}>Edit</div>
      </div>
    );
  }
});
