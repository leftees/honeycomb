/** @jsx React.DOM */

var ItemPublishEmbedPanel = React.createClass({
  propTypes: {
    publish_panel_title: React.PropTypes.string.isRequired,
    publish_panel_help: React.PropTypes.string.isRequired,
    publish_panel_field_name: React.PropTypes.string.isRequired,
    embed_panel_title: React.PropTypes.string.isRequired,
    embed_panel_title: React.PropTypes.string.isRequired,
    published: React.PropTypes.bool.isRequired,
  },
  getInitialState: function() {
    return { published: this.props.published }
  },
  embedPanel: function () {
    var embed;
    if (this.state.published) {
      embed = (<ItemEmbedPanel embed_panel_title={this.props.embed_panel_title} embed_panel_help={this.props.embed_panel_help} />)
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
            publish_panel_title={this.props.publish_panel_title}
            publish_panel_help={this.props.publish_panel_help}
            publish_panel_field_name={this.props.publish_panel_field_name}
          />

        {this.embedPanel()}
      </div>
    )
  }
});
