/** @jsx React.DOM */

var NewSectionDropzone = React.createClass({
  getInitialState: function() {
    return {
      hover: false
    };
  },
  style: function() {
    return {
      display: 'inline-block',
      height: '100%',
    };
  },
  innerStyle: function() {
    var styles = {
      color: 'rgba(0, 0, 0, 0)',
      border: '#333 dashed',
      height: '100%',
      width: '40px',
      transitionProperty: 'all',
      transitionDuration: '.5s',
      transitionTimingFunction: 'cubic-bezier(0, 1, 0.5, 1)',
      overflow: 'hidden',
    };
    if (this.state.hover) {
      styles.width = '200px';
      styles.backgroundColor = '#ededed';
      styles.color = '#333';
      styles.padding = '14px';
    }
    return styles;
  },
  contentStyle: function() {
    return {
      opacity: (this.state.hover ? 1 : 0)
    };
  },
  classes: function() {
    return ['section-spacer', this.active() ? 'active' : void 0, this.state.hover ? 'hover active' : void 0].join(' ');
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
  active: function() {
    return this.props.currentDragItem;
  },
  activeHover: function() {
    return this.active() && this.state.hover;
  },
  onDrop: function() {
    if (this.active()) {
      return this.props.onDrop(this.props.currentDragItem, this.props.new_index);
    }
  },
  render: function() {
    url = "sections/new?section[order]=" + this.props.new_index
    return (
      <div style={this.style()} className={this.classes()} onMouseEnter={this.onMouseEnter} onMouseLeave={this.onMouseLeave} onMouseUp={this.onDrop}>
        <div className="section-spacer-inner" style={this.innerStyle()}>
          <div className="section-spacer-content center" style={this.contentStyle()}>
            <h4>Add New Section</h4>
            <p><i className="glyphicon glyphicon-picture super-large-icon"></i></p>
            <p>Drag a saved item or<br/><a href={url}><strong>Add Text</strong></a></p>
          </div>
        </div>
     </div>);
  }
});
