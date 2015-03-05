/** @jsx React.DOM */

var ItemPublishPanel = React.createClass({
  propTypes: {
    publishPanelTitle: React.PropTypes.string.isRequired,
    publishPanelHelp: React.PropTypes.string.isRequired,
    publishPanelFieldName: React.PropTypes.string.isRequired,
    published: React.PropTypes.bool.isRequired,
    togglePublished: React.PropTypes.func.isRequired,
  },
  handleClick: function () {
    this.props.togglePublished();
  },
  render: function () {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">{this.props.publishPanelTitle}</h3>
        </div>
        <div className="panel-body">
          <p>{this.props.publishPanelHelp}</p>
          <label>
            <input type="checkbox" checked={this.props.published} onChange={this.handleClick} /> {this.props.publishPanelFieldName}
          </label>
        </div>
      </div>
    )
  }
});
