var ItemShowImageBox = React.createClass({
  propTypes: {
    image: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.object,
    ]),
    itemID: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      image: null,
    };
  },

  componentDidMount: function() {
    // $.get(this.props.image, function(result) {
    //   this.setState({
    //     image: result,
    //   })
    // }.bind(this));
  },

  render: function() {
    return (
      <div className="hc-item-show-image-box">
        <ItemImageZoomButton image={this.props.image} itemID={this.props.itemID} />
        <Thumbnail image={this.props.image} />
      </div>
    );
  }
});
