/** @jsx React.DOM */

var CollectionPreviewPublish = React.createClass({
  propTypes: {
    collection: React.PropTypes.object.isRequired,
    previewModePath: React.PropTypes.string.isRequired,
    previewLinkURL: React.PropTypes.string.isRequired,
    previewLinkLabel: React.PropTypes.string.isRequired,
    liveLinkLabel: React.PropTypes.string.isRequired,
    publishPath: React.PropTypes.string.isRequired,
    unpublishPath: React.PropTypes.string.isRequired
  },

  getInitialState: function() {
    return {
      published: this.props.collection.published,
      preview: this.props.collection.preview_mode,
    };
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

  handlePreviewClick: function(newValue) {
    this.setState({ preview: newValue });
  },

  handlePublishClick: function(newValue) {
    this.setState({ published: newValue });
  },

  render: function () {
    return (
        <div>
          <li className="header" role="presentation">Publishing Status</li>
          <li className="togglebutton">
            <CollectionPublishToggle onToggle={this.handlePublishClick} ref="myPublishToggle" collection={this.props.collection} publishPath={this.props.publishPath} unpublishPath={this.props.unpublishPath} />
          </li>
          <li className="header" role="presentation">Preview Mode</li>
          <li className="togglebutton">
            <CollectionPreviewModeToggle onToggle={this.handlePreviewClick} ref="myPreviewToggle" collection={this.props.collection} previewModePath={this.props.previewModePath} previewLinkURL={this.props.previewLinkURL}/>
          </li>
          {this.siteLink()}
        </div>
      )
  }
});
