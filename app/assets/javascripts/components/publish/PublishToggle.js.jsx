/** @jsx React.DOM */

var PublishToggle = React.createClass({
  propTypes: {
    publishPanelFieldName: React.PropTypes.string.isRequired,
    published: React.PropTypes.bool.isRequired,
    togglePublished: React.PropTypes.func.isRequired,
  },
  handleClick: function () {
    this.props.togglePublished();
  },
  render: function () {
    return (
      <label>
        <input type="checkbox" checked={this.props.published} onChange={this.handleClick} /> {this.props.publishPanelFieldName}
      </label>
    )
  }
});
