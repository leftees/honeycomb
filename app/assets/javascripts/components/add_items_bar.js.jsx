/** @jsx React.DOM */

var AddItemsBar;

AddItemsBar = React.createClass({
  propTypes: {
    itemsJSONPath: React.PropTypes.string.isRequired
  },
  getInitialState: function() {
    return {
      items: []
    };
  },
  loadItemsFromServer: function() {
    $.ajax({
      url: this.props.itemsJSONPath,
      dataType: "json",
      success: (function(data) {
        this.setState({
          items: data.items
        });
      }).bind(this),
      error: (function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }).bind(this)
    });
  },
  componentDidMount: function() {
    this.loadItemsFromServer();
    setInterval(this.loadItemsFromServer(), 8000);
  },
  render: function() {
    return (<ItemList onDragStart={this.props.onDragStart} onDragStop={this.props.onDragStop} items={this.state.items} />);
  }
});
