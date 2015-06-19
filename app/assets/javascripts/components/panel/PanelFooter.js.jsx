/** @jsx React.DOM */
var React = require('react');
var PanelFooter = React.createClass({
  propTypes: {
    children: React.PropTypes.element.isRequired
  },
  render: function () {
    return (
      <div className="panel-footer">
        {this.props.children}
      </div>
    );
  }
});
module.exports = PanelFooter;
