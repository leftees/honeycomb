/** @jsx React.DOM */

var ShowcaseEditorTitle = React.createClass({
  propTypes: {
  },

  getInitialState: function() {
    return {
    };
  },
  style: function() {
    return {
      border: '1px solid lightgrey',
      float: 'left',
      position: 'relative',
      padding: '5px',
      height: '100%',
      marginRight: '10px',
    };
  },

  render: function() {
    return (
      <div className="showcase-title-page" style={this.style()}>
        <h2>Showcase Title</h2>
        <p>This is the showcase description</p>
      </div>
    );
  }
});
