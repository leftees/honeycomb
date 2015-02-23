/** @jsx React.DOM */

var CuratorListRow = React.createClass({
  render: function() {
    return (
      <tr className="curator-list-row">
        <td>
          {this.props.curator.name}
        </td>
        <td>
          <a className="remove_curator pull-right" data-confirm="Are you sure?" data-method="delete" href={this.props.curator.removeUrl} rel="nofollow">x</a>
        </td>
      </tr>
    );
  }
});
