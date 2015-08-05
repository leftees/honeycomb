var React = require("react");
var EventEmitter = require('../EventEmitter');
var mui = require("material-ui");
var Snackbar = mui.Snackbar;

var PageMessage = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],
  getInitialState: function() {
    return {
      messageType: "",
      messageText: "",
    };
  },

  componentDidMount: function () {
    EventEmitter.emit("MessageCenterDisplay", this.props.messageType, this.props.messageText);
  },

  render: function () {
    return ( null );
  }
});
module.exports = PageMessage;
