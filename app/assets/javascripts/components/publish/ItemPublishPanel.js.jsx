/** @jsx React.DOM */

var ItemPublishPanel = React.createClass({
  propTypes: {
    publish_panel_title: React.PropTypes.string.isRequired,
    publish_panel_help: React.PropTypes.string.isRequired,
    publish_panel_field_name: React.PropTypes.string.isRequired,
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
          <h3 className="panel-title">{this.props.publish_panel_title}</h3>
        </div>
        <div className="panel-body">
          <p>{this.props.publish_panel_help}</p>
          <label>
            <input type="checkbox" checked={this.props.published} onChange={this.handleClick} /> {this.props.publish_panel_field_name}
          </label>
        </div>
      </div>
    )
  }
});
