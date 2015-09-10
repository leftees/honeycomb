var React = require('react');
var UserListRow = React.createClass({
  render: function() {
    return (
      <tr className="user-list-row">
        <td>
          {this.props.user.name}
        </td>
        <td>
          {this.props.user.username}
        </td>
        <td>
          <a className="remove-user pull-right"
            data-confirm="Are you sure?"
            data-method="delete"
            href={this.props.user.removeUrl}
            rel="nofollow">
            <span className="glyphicon glyphicon-trash"></span>
          </a>
        </td>
      </tr>
    );
  }
});
module.exports = UserListRow;
