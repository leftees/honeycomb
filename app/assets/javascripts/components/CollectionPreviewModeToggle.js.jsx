/** @jsx React.DOM */

var CollectionPreviewModeToggle = React.createClass({
  propTypes: {
    collection: React.PropTypes.object.isRequired,
    previewModePath: React.PropTypes.string.isRequired
  },
  getInitialState: function() {
    return {
      preview_mode: this.props.collection.preview_mode,
      preview_mode_label: this.previewLabel(this.props.collection.preview_mode)
    };
  },
  handleClick: function () {
    this.togglePreviewMode();
  },
  previewLabel: function (preview_status) {
    var label;
    if (preview_status) {
      label = 'Preview Enabled'
    } else {
      label = 'Preview Not Enabled'
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
          preview_mode_label: this.previewLabel(preview_state)
        });
      }).bind(this),
      error: (function(xhr, status, err) {
        console.error(actionUrl, status, err.toString());
      }).bind(this)
    });
},
render: function () {
  return (
    <label>
    <input type="checkbox" checked={this.state.preview_mode} onChange={this.handleClick}/>
    <span className="toggle"></span><span className="toggle-label">{this.state.preview_mode_label}</span>
    </label>
    )
}
});
