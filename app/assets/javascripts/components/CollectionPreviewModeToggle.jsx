var React = require("react");
var mui = require("material-ui");
var Toggle = mui.Toggle;
var CollectionActions = require('../actions/Collection');
var CollectionActionTypes = require('../constants/CollectionActionTypes');
var CollectionStore = require('stores/Collection');

var CollectionPreviewModeToggle = React.createClass({
  mixins: [MuiThemeMixin],
  propTypes: {
    previewModePath: React.PropTypes.string.isRequired,
    onToggle: React.PropTypes.func
  },
  
  componentWillMount: function() {
    CollectionStore.on("CollectionStoreChanged", this.collectionStoreChanged);
  },

  collectionStoreChanged: function() {
    this.setState({
      preview_mode: CollectionStore.preview,
    }, this.stateChanged);
  },

  getInitialState: function() {
    return {
      preview_mode: CollectionStore.preview,
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
    CollectionActions.changePreview(preview_state, this.props.previewModePath);
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
