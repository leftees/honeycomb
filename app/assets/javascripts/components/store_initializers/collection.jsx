/** @jsx React.DOM */
var React = require("react");
var CollectionActions = require('../../actions/Collection');

var CollectionStoreInitializer = React.createClass({
  propTypes: {
    collection: React.PropTypes.object.isRequired,
  },

  componentWillMount: function() {
    CollectionActions.setState({
      preview: this.props.collection.preview_mode,
      published: this.props.collection.published,
      title: this.props.collection.title
    });
  },
  render: function() {
    return <div/>
  }
});

module.exports = CollectionStoreInitializer;
