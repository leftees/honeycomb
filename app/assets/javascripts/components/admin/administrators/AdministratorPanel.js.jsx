/** @jsx React.DOM */

var AdministratorPanel = React.createClass({
  propTypes: {
    initialAdministrators: React.PropTypes.array.isRequired,
  },
  getInitialState: function() {
    return {
      administrators: this.props.initialAdministrators
    };
  },
  addAdministrator: function(personId) {
    $.ajax({
        url: this.props.createUrl,
        dataType: "json",
        type: "POST",
        data: {
            user: {
                username: personId
            }
        },
        success: (function(data) {
          this.administratorAdded(data);
        }).bind(this),
        error: (function(xhr, status, err) {
            console.error(this.props.createUrl, status, err.toString());
        }).bind(this)
    });
  },
  administratorExists: function(administratorId) {
    return _.some(this.state.administrator, function(administrator) {
      return administrator.id == administratorId;
    });
  },
  administratorAdded: function(administrator) {
    if (!this.administratorExists(administrator.id)) {
      var newAdministrators = this.state.administrators.concat([administrator]);
      this.setState({
        administrators: newAdministrators
      });
    }
  },
  render: function() {
    return (
      <div className="administrator-panel panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Administrators</h3>
        </div>
        <AdministratorList administrators={this.state.administrators} />
        <div className="panel-footer">
          <PeopleSearch
            createUrl={this.props.createUrl}
            searchUrl={this.props.searchUrl}
            selectPerson={this.addAdministrator} />
        </div>
      </div>
    );
  }
});
