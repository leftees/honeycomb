/** @jsx React.DOM */

var ItemEmbedPanel = React.createClass({
  propTypes: {
    embed_panel_title: React.PropTypes.string.isRequired,
    embed_panel_help: React.PropTypes.string.isRequired,
  },
  render: function () {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">{this.props.embed_panel_title}</h3>
        </div>
        <div className="panel-body">
          <p>{this.props.embed_panel_help}</p>
          <p><textarea defaultValue="I AM AN EMBED CODE !!! I AM SO AWESOME.  YOUR WEBSITE WILL BE AMAZING WITH ME !" /></p>
        </div>
      </div>
    )
  }
})
