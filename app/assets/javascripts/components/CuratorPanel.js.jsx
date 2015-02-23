/** @jsx React.DOM */

var CuratorPanel = React.createClass({
  propTypes: {
    initialCurators: React.PropTypes.array.isRequired,
  },
  getInitialState: function() {
    return {
      curators: this.props.initialCurators
    };
  },
  addCurator: function(personId) {
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
          this.curatorAdded(data);
        }).bind(this),
        error: (function(xhr, status, err) {
            console.error(this.props.createUrl, status, err.toString());
        }).bind(this)
    });
  },
  curatorExists: function(curatorId) {
    return _.some(this.state.curators, function(curator) {
      return curator.id == curatorId;
    });
  },
  curatorAdded: function(curator) {
    if (!this.curatorExists(curator.id)) {
      var newCurators = this.state.curators.concat(curator);
      this.setState({
        curators: newCurators
      });
    }
  },
  render: function() {
    return (
      <div className="curator-panel panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Curators</h3>
        </div>
        <CuratorList curators={this.state.curators} />
        <div className="panel-footer">
          <PeopleSearch
            createUrl={this.props.createUrl}
            searchUrl={this.props.searchUrl}
            selectPerson={this.addCurator} />
        </div>
      </div>
    );
  }
});
