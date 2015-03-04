/** @jsx React.DOM */

var ItemPublishEmbedPanel = React.createClass({
  propTypes: {
    publishPanelTitle: React.PropTypes.string.isRequired,
    publishPanelHelp: React.PropTypes.string.isRequired,
    publishPanelFieldName: React.PropTypes.string.isRequired,
    embedPanelTitle: React.PropTypes.string.isRequired,
    embedPanelHelp: React.PropTypes.string.isRequired,
    published: React.PropTypes.bool.isRequired,
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
    this.setState({
      published: !this.state.published,
    })
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
