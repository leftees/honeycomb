var React = require("react");
var EventEmitter = require('../EventEmitter');
var mui = require("material-ui");
var Snackbar = mui.Snackbar;

// Sends flash messages to the message center. To send html in the message, use flash[:html_safe]
var FlashMessage = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],
  
  getInitialState: function() {
    return {
      messageType: "",
      messageText: "",
    };
  },

  componentDidMount: function () {
    Flash.transferFromCookies();
    for(var key in Flash.data) {
      EventEmitter.emit("MessageCenterDisplay", key, Flash.data[key].toString().replace(/\+/g, ' '), key == "html_safe");
    }
  },

  render: function () {
    return ( null );
  }
});

module.exports = FlashMessage;
