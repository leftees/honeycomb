/** @jsx React.DOM */

var ItemPublishEmbedPanel = React.createClass({
  propTypes: {
    publishPanelTitle: React.PropTypes.string.isRequired,
    publishPanelHelp: React.PropTypes.string.isRequired,
    publishPanelFieldName: React.PropTypes.string.isRequired,
    embedPanelTitle: React.PropTypes.string.isRequired,
    embedPanelHelp: React.PropTypes.string.isRequired,
    published: React.PropTypes.bool.isRequired,
    publishPath: React.PropTypes.string.isRequired,
    unpublishPath: React.PropTypes.string.isRequired,
  },
  getInitialState: function() {
    return { published: this.props.published }
  },
  embedPanel: function () {
    var embed;
    if (this.state.published) {
      embed = (<ItemEmbedPanel
                  embedPanelTitle={this.props.embedPanelTitle}
                  embedPanelHelp={this.props.embedPanelHelp} />
              )
    }
    return embed
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
        <ItemPublishPanel
            togglePublished={this.togglePublished}
            published={this.state.published}
            publishPanelTitle={this.props.publishPanelTitle}
            publishPanelHelp={this.props.publishPanelHelp}
            publishPanelFieldName={this.props.publishPanelFieldName}
          />

        {this.embedPanel()}
      </div>
    )
  }
});
