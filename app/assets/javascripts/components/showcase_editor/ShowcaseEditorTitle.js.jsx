/** @jsx React.DOM */

var ShowcaseEditorTitle = React.createClass({
  propTypes: {
  },

  getInitialState: function() {
    return {
      hover: false,
    };
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

  style: function() {
    return {
      border: '1px solid lightgrey',
      display: 'inline-block',
      verticalAlign: 'top',
      position: 'relative',
      padding: '5px',
      height: '100%',
      marginRight: '10px',
    };
  },

  editTitle: function() {

  },

  render: function() {
    return (
      <div className="showcase-title-page" style={this.style()} onMouseEnter={this.onMouseEnter} onMouseLeave={this.onMouseLeave}>
        <h2>Showcase Title</h2>
        <p>This is the showcase description</p>
        <EditLink clickHandler={this.editTitle} visible={this.state.hover} />
      </div>
    );
  }
});
