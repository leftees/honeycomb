var React = require("react");
var EventEmitter = require('../../EventEmitter');
var mui = require("material-ui");
var Snackbar = mui.Snackbar;

var FormMessageCenter = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],
  getInitialState: function() {
    return {
      messageType: "",
      messageText: "",
    };
  },
  componentWillMount: function() {
    EventEmitter.on("MessageCenterDisplay", this.receiveDisplay);
  },

  receiveDisplay: function(messageType, messageText) {
    this.setState({
      messageType: messageType,
      messageText: messageText,
    });
    this.refs.errorDialog.show();
  },

  dismissMessage: function() {
    this.refs.errorDialog.dismiss();
  },


  render: function () {
    return (
      <Snackbar
        ref = "errorDialog"
        message={this.state.messageText}
      >

      </Snackbar>
    );
  }
});
module.exports = FormMessageCenter;
