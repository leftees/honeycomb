/** @jsx React.DOM */
var React = require("react");
var mui = require("material-ui");
var Toggle = mui.Toggle;
var CollectionPreviewModeToggle = React.createClass({
  mixins: [MuiThemeMixin],
  propTypes: {
    collection: React.PropTypes.object.isRequired,
    previewModePath: React.PropTypes.string.isRequired,
    onToggle: React.PropTypes.func
  },

  getInitialState: function() {
    return {
      preview_mode: this.props.collection.preview_mode,
    };
  },

  handleClick: function () {
    this.togglePreviewMode();
  },

  stateChanged: function() {
    if(this.props.onToggle)
      this.props.onToggle(this.state.preview_mode);
  },

  previewLabel: function () {
    var label;
    if (this.state.preview_mode) {
      label = 'Enabled'
    } else {
      label = 'Disabled'
    }
    return label;
  },

  togglePreviewMode: function () {
    var preview_state;
    if (this.state.preview_mode) {
      preview_state = false;
    } else {
      preview_state = true;
    }
    $.ajax({
      url: this.props.previewModePath,
      dataType: "json",
      data: {
        value: preview_state
      },
      method: "PUT",
      success: (function(data) {
        this.setState({
          preview_mode: preview_state,
        }, this.stateChanged);
      }).bind(this),
      error: (function(xhr, status, err) {
        console.error(actionUrl, status, err.toString());
      }).bind(this)
    });
  },

  render: function () {
    return (
      <Toggle
        label={this.previewLabel()}
        defaultToggled={this.state.preview_mode}
        onToggle={this.handleClick}
      />
    )
  }
});
module.exports = CollectionPreviewModeToggle;
