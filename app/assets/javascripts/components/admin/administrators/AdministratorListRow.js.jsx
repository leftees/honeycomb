/** @jsx React.DOM */

var AdministratorListRow = React.createClass({
  render: function() {
    return (
      <tr className="administrator-list-row">
        <td>
          {this.props.administrator.name}
        </td>
        <td>
          {this.props.administrator.username}
        </td>
        <td>
          <a className="remove-administrator pull-right" data-confirm="Are you sure?" data-method="delete" href={this.props.administrator.removeUrl} rel="nofollow">x</a>
        </td>
      </tr>
    );
  }
});
