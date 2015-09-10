var React = require('react');
var mui = require('material-ui');
var CircularProgress = mui.CircularProgress;
var EventEmitter = require("../EventEmitter");

var ItemShowImageBox = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    image: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.object,
    ]),
    itemID: React.PropTypes.string.isRequired,
    item: React.PropTypes.object,         // Item object from ItemDecorator
    itemPath: React.PropTypes.string,     // The path to the API to retrieve item's image details
    maxRetries: React.PropTypes.number,   // Max number of times it should retry to get the image
    retryInterval: React.PropTypes.number // How frequent it should retry to get the image, in ms
  },

  getDefaultProps: function() {
    return {
      maxRetries: 3,       // Defaulting to 3 retries, 5s apart, total wait of 15s
      retryInterval: 5000
    };
  },

  getInitialState: function() {
    return {
      imageReady: false,
      requestTimer: 0,
      requestCount: 0,
      image: this.props.image,
    };
  },

  checkImageState: function(image) {
    if(image["items"]["image_status"] == "image_ready") {
      this.setState({
        imageReady: true,
        image: image["items"]["image"],
      });
      clearInterval(this.state.requestTimer);
    } else if(image["items"]["image_status"] == "image_invalid") {
      EventEmitter.emit("MessageCenterDisplay", "error", "There was a problem loading the media. Try replacing or contacting support.");
      clearInterval(this.state.requestTimer);
    }
  },

  pingItem: function() {
    $.ajax({
      url: this.props.itemPath,
      dataType: "json",
      method: "GET",
      success: this.checkImageState,
      error: (function(xhr) {
        EventEmitter.emit("MessageCenterDisplay", "error", "There was a problem loading the media. Please contact support.");
        console.log(xhr);
      }),
    });

    this.setState({ requestCount: this.state.requestCount + 1 });
    if(this.state.requestCount >= this.props.maxRetries) {
      EventEmitter.emit("MessageCenterDisplay", "error", "Media is still being processed. Please try again later.");
      clearInterval(this.state.requestTimer);
    }
  },

  componentWillMount: function() {
    if(this.props.item.image_status == "image_ready") {
      this.setState({
        imageReady: true,
      });
    } else if(this.props.item.image_status == "image_invalid") {
      EventEmitter.emit("MessageCenterDisplay", "error", "There was a problem loading the media. Try replacing or contacting support.");
    } else {
      this.setState({
        requestTimer: setInterval(this.pingItem, this.props.retryInterval),
        imageReady: false,
      });
    }
  },

  componentWillUnmount: function() {
    // just in case
    if(this.state.requestTimer != 0) {
      clearInterval(this.state.requestTimer);
    }
  },

  render: function() {
    if(this.state.imageReady) {
      return (
        <div className="hc-item-show-image-box">
          <ItemImageZoomButton image={this.state.image} itemID={this.props.itemID} />
          <Thumbnail image={this.state.image} />
        </div>
      );
    } else {
      return (
        <div>
          <CircularProgress mode="indeterminate" size={0.5} />
        </div>
      );
    }
  }
});
module.exports = ItemShowImageBox;
