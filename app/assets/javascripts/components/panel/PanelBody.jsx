/** @jsx React.DOM */
var React = require('react');
var PanelBody = React.createClass({
  propTypes: {
    children: React.PropTypes.any
  },
  render: function () {
    return (
      <div className="panel-body">
        {this.props.children}
      </div>
    );
  }
});
module.exports = PanelBody;
