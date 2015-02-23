/** @jsx React.DOM */

var AdministratorList = React.createClass({
  render: function() {
    var administratorRows = this.props.administrators.map(function(administrator) {
      return (
        <AdministratorListRow key={administrator.id} administrator={administrator} />
      );
    });

    return (
      <table className="table table-hover administrator-list">
        <thead>
          <th>Name</th>
          <th>NetID</th>
          <th></th>
        </thead>
        <tbody>
          {administratorRows}
        </tbody>
      </table>
    );
  }
});
