/** @jsx React.DOM */
var React = require('react');
var mui = require("material-ui");
var Toggle = mui.Toggle;
var PublishToggle = React.createClass({
  mixins: [MuiThemeMixin],
  propTypes: {
    publishPanelFieldName: React.PropTypes.string.isRequired,
    published: React.PropTypes.bool.isRequired,
    togglePublished: React.PropTypes.func.isRequired,
  },

  publishLabel: function () {
    var label;
    if (this.props.published) {
      label = 'Publishedxxx'
    } else {
      label = 'Not Published'
    }
    return label;
  },

  handleClick: function () {
    this.props.togglePublished();
  },
  render: function () {
    return (
      <Toggle
        label={this.publishLabel()}
        defaultToggled={this.props.published}
        onToggle={this.handleClick}
      />
    )
  }
});
module.exports = PublishToggle;
