/** @jsx React.DOM */

var ItemEmbedPanel = React.createClass({
  propTypes: {
    embedPanelTitle: React.PropTypes.string.isRequired,
    embedPanelHelp: React.PropTypes.string.isRequired,
  },
  render: function () {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">{this.props.embedPanelTitle}</h3>
        </div>
        <div className="panel-body">
          <p>{this.props.embedPanelHelp}</p>
          <p><textarea defaultValue="I AM AN EMBED CODE !!! I AM SO AWESOME.  YOUR WEBSITE WILL BE AMAZING WITH ME !" /></p>
        </div>
      </div>
    )
  }
})
