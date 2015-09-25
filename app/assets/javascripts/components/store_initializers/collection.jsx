var React = require("react");
var CollectionActions = require('../../actions/Collection');

var CollectionStoreInitializer = React.createClass({
  propTypes: {
    collection: React.PropTypes.object.isRequired,
  },

  componentWillMount: function() {
    CollectionActions.setState(this.props.collection);
  },

  render: function() {
    return <div/>
  }
});

module.exports = CollectionStoreInitializer;
