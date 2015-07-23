/** @jsx React.DOM */
var React = require("react");
var CollectionStore = require('stores/Collection');

var CollectionPreviewPublishLink = React.createClass({
  propTypes: {
    previewLinkURL: React.PropTypes.string.isRequired,
    previewLinkLabel: React.PropTypes.string.isRequired,
    liveLinkLabel: React.PropTypes.string.isRequired,
  },

  componentWillMount: function() {
    CollectionStore.on("CollectionStoreChanged", this.collectionStoreChanged);
  },

  getInitialState: function() {
    return {
      published: CollectionStore.published,
      preview: CollectionStore.preview,
    };
  },

  collectionStoreChanged: function() {
    this.setState({
      preview: CollectionStore.preview,
      published: CollectionStore.published
    });
  },

  linkLabel: function () {
    if (this.state.published) {
      return this.props.liveLinkLabel;
    }
    return this.props.previewLinkLabel;
  },

  siteLink: function() {
    if(this.state.published || this.state.preview) {
      return (
        <a href={this.props.previewLinkURL} target="_blank">
          <i className="glyphicon mdi-av-web"></i>
          <span> {this.linkLabel()}</span>
        </a>)
    } else {
      return "";
    }
  },

  render: function () {
    return (
      <div>
        {this.siteLink()}
      </div>
    )
  }
});
module.exports = CollectionPreviewPublishLink;
