/** @jsx React.DOM */

var CollectionPublishToggle = React.createClass({
  propTypes: {
    collection: React.PropTypes.object.isRequired,
    publishPath: React.PropTypes.string.isRequired,
    unpublishPath: React.PropTypes.string.isRequired
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
        });
      }).bind(this),
      error: (function(xhr, status, err) {
        console.error(searchUrl, status, err.toString());
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
