/** @jsx React.DOM */
var React = require('react');
var EditLink = React.createClass({

  propTypes: {
    clickHandler: React.PropTypes.func.isRequired,
    visible: React.PropTypes.bool,
  },

  style: function() {
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
    if (!this.props.visible) {
      styles.visibility = 'hidden';
    }
    return styles;
  },

  handleClick: function(e) {
    e.preventDefault();
    this.props.clickHandler();
  },

  render: function() {
    return (
      <div className="edit-link" onClick={this.handleClick} style={this.style()}>Edit</div>
    );
  }
});
module.exports = EditLink;
