//app/assets/javascripts/components/forms/FieldHelp.jsx
var React = require('react');
var FieldHelp = React.createClass({

  propTypes: {
    children: React.PropTypes.oneOfType([
      React.PropTypes.object,
      React.PropTypes.array,
      React.PropTypes.string,
    ])
  },

  render: function () {
    return (
      <p className="help-block">{this.props.children}</p>
    );
  }
});

module.exports = FieldHelp;
