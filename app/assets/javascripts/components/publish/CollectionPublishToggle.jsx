var React = require("react");
var mui = require("material-ui");
var Toggle = mui.Toggle;
var CollectionActions = require('../../actions/Collection');
var CollectionActionTypes = require('../../constants/CollectionActionTypes');
var CollectionStore = require('stores/Collection');

var CollectionPublishToggle = React.createClass({
  mixins: [APIResponseMixin, MuiThemeMixin],
  propTypes: {
    publishPath: React.PropTypes.string.isRequired,
    unpublishPath: React.PropTypes.string.isRequired,
    onToggle: React.PropTypes.func
  },
  componentWillMount: function() {
    CollectionStore.on("CollectionStoreChanged", this.collectionStoreChanged);
  },
  collectionStoreChanged: function() {
    this.setState({
      published: CollectionStore.published,
      published_label: this.publishedLabel(CollectionStore.published)
    }, this.stateChanged);
  },
  getInitialState: function() {
    return {
      published: CollectionStore.published,
      published_label: this.publishedLabel(CollectionStore.published)
    };
  },
  handleClick: function () {
    this.togglePublished();
  },
  stateChanged: function() {
    if(this.props.onToggle)
      this.props.onToggle(this.state.published);
  },
  publishedLabel: function (published_status) {
    var label;
    if (published_status) {
      label = 'Published'
    } else {
      label = 'Not Published'
    }
    return label;
  },
  togglePublished: function () {
    var publishUrl;
    var published_state;
    if (this.state.published) {
      publishUrl = this.props.unpublishPath;
      published_state = false;
    } else {
      publishUrl = this.props.publishPath;
      published_state = true;
    }
    CollectionActions.changePublished(published_state, publishUrl);
  },
  render: function () {
    return (
      <Toggle
        label={this.state.published_label}
        defaultToggled={this.state.published}
        onToggle={this.handleClick}
      />
    )
  }
});
module.exports = CollectionPublishToggle;
