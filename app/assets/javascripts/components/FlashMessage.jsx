var React = require("react");
var EventEmitter = require('../EventEmitter');
var mui = require("material-ui");
var Snackbar = mui.Snackbar;

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
      EventEmitter.emit("MessageCenterDisplay", key, Flash.data[key].toString().replace(/\+/g, ' '));
    }
  },

  render: function () {
    return ( null );
  }
});

module.exports = FlashMessage;
