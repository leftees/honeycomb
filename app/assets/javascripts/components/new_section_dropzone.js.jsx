/** @jsx React.DOM */

var NewSectionDropzone = React.createClass({
  getInitialState: function() {
    return {
      hover: false
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
  onDrop: function() {
    if (this.active()) {
      return this.props.onDrop(this.props.currentDragItem, this.props.new_index);
    }
  },
  render: function() {
    url = "sections/new?section[order]=" + this.props.new_index
    return (
      <div className={this.classes()} onMouseEnter={this.onMouseEnter} onMouseLeave={this.onMouseLeave} onMouseUp={this.onDrop}>
        <div className="section-spacer-inner">
          <div className="section-spacer-content center">
            <h4>Add New Section</h4>
            <p><i className="glyphicon glyphicon-picture super-large-icon"></i></p>
            <p>Drag a saved item or<br/><a href={url}><strong>Add Text</strong></a></p>
          </div>
        </div>
     </div>);
  }
});
