var React = require('react');
var ShowcasePublishAction = React.createClass({
  propTypes: {
    published: React.PropTypes.bool.isRequired,
    publishPath: React.PropTypes.string.isRequired,
    unpublishPath: React.PropTypes.string.isRequired,
    publishPanelFieldName: React.PropTypes.string.isRequired,
  },
  getInitialState: function() {
    return { published: this.props.published }
  },
  togglePublished: function () {
    this.setState(
      { published: !this.state.published, },
      this.savePublished
    );
  },
  savePublished: function () {
    var path = this.props.publishPath;
    if (!this.state.published) {
      path = this.props.unpublishPath;
    }

    $.ajax({
      url: path,
      dataType: "json",
      type: "POST",
      data: {
        "_method": "put"
      },
      error: (function(xhr, status, err) {
        this.setState({
          published: !this.state.published,
        });
        console.error(this.props.url, status, err.toString());
      }).bind(this)
    });
  },
  render: function () {
    return (
      <div>
      {/*
      <PublishToggle
        togglePublished={this.togglePublished}
        published={this.state.published}
        publishPanelFieldName={this.props.publishPanelFieldName} />
      */}
      </div>
    )
  }
});
module.exports = ShowcasePublishAction;
