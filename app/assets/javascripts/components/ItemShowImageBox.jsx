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
      maxRetries: 3,       // Maximum number of times it will retry to get the image status.
      retryInterval: 5000  // Time in ms to wait before retrying request for image status.
    };
  },

  getInitialState: function() {
    return {
      image: null,
      imageReady: false,
      requestTimer: 0,
      requestCount: 0,
      image: this.props.image,
      awaitingResponse: false
    };
  },

  checkImageState: function(image) {
    switch(image["items"]["image_status"])
    {
      case "image_ready":
        this.setState({
          imageReady: true,
          image: image["items"]["image"],
        });
        clearInterval(this.state.requestTimer);
        break;
      case "image_processing":
        if(this.state.requestCount >= this.props.maxRetries) {
          EventEmitter.emit("MessageCenterDisplay", "error", "Media is still being processed. Please try again later.");
          clearInterval(this.state.requestTimer);
        }
        break;
      default:
        EventEmitter.emit("MessageCenterDisplay", "error", "There was a problem loading the media. Try replacing or contacting support.");
        clearInterval(this.state.requestTimer);
        break;
    }
  },

  pingItem: function() {
    if(this.state.awaitingResponse)
      return;

    this.setState({
      awaitingResponse: true,
      requestCount: this.state.requestCount + 1
    });

    $.ajax({
      url: this.props.itemPath,
      dataType: "json",
      method: "GET",
      success: (function(data) {
        this.checkImageState(data);
        this.setState({ awaitingResponse: false });
      }).bind(this),
      error: (function(xhr) {
        EventEmitter.emit("MessageCenterDisplay", "error", "There was a problem loading the media. Please contact support.");
        console.log(xhr);
        clearInterval(this.state.requestTimer);
        this.setState({ awaitingResponse: false });
      }).bind(this),
    });
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
