/** @jsx React.DOM */

var CollectionPublishToggle = React.createClass({
  propTypes: {
    collection: React.PropTypes.object.isRequired,
  },
  handleClick: function () {
    this.props.togglePublished();
  },
  togglePublished: function () {
    this.setState(
      { published: !this.state.published, },
      this.savePublished
      );
  },
  render: function () {
    return (
      <label>
        <input type="checkbox" checked={this.props.published} onChange={this.handleClick} /> {this.props.publishPanelFieldName}
      </label>
    )
  }
});
