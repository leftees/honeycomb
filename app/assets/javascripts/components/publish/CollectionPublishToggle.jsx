/** @jsx React.DOM */
var React = require("react");
var mediator = require("../../mediator");
var CollectionPublishToggle = React.createClass({
  mixins: [APIResponseMixin],
  propTypes: {
    collection: React.PropTypes.object.isRequired,
    publishPath: React.PropTypes.string.isRequired,
    unpublishPath: React.PropTypes.string.isRequired,
    onToggle: React.PropTypes.func
  },
  componentWillMount: function() {
    mediator.subscribe("test", this);
  },
  receive: function(message) {
    console.log("CollectionPublishToggle received " + message);
  },
  getInitialState: function() {
    return {
      published: this.props.collection.published,
      published_label: this.publishedLabel(this.props.collection.published)
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
    var searchUrl;
    var published_state;
    if (this.state.published) {
      searchUrl = this.props.unpublishPath;
      published_state = false;
    } else {
      searchUrl = this.props.publishPath;
      published_state = true;
    }
    $.ajax({
      url: searchUrl,
      dataType: "json",
      method: "PUT",
      success: (function(data) {
        this.setState({
          published: published_state,
          published_label: this.publishedLabel(published_state)
        }, this.stateChanged);
      }).bind(this),
      error: (function(xhr, status, err) {
        mediator.send("MessageCenterDisplay", ["error", this.apiErrorToString(xhr)]);
      }).bind(this)
    });
  },
  render: function () {
    return (
      <label>
      <input type="checkbox" checked={this.state.published} onChange={this.handleClick}/>
      <span className="toggle"></span><span className="toggle-label">{this.state.published_label}</span>
      </label>
      )
  }
});
module.exports = CollectionPublishToggle;
