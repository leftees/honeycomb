/** @jsx React.DOM */

var Panel = React.createClass({
  propTypes: {
    PanelTitle: React.PropTypes.string.isRequired,
    children: React.PropTypes.element.isRequired
  },
  render: function () {
    return (
      <div className="panel panel-default">
        {this.props.children}
      </div>
    );
  }
});
