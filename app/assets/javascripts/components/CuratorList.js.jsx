/** @jsx React.DOM */

var CuratorList = React.createClass({
  render: function() {
    var curatorRows = this.props.curators.map(function(curator) {
      return (
        <CuratorListRow key={curator.id} curator={curator} />
      );
    });

    return (
      <table className="table table-hover curator-list">
        <tbody>
          {curatorRows}
        </tbody>
      </table>
    );
  }
});
