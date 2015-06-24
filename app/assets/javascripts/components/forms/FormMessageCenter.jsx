var React = require("react");
var mediator = require("../../mediator");
var mui = require("material-ui");
var Dialog = mui.Dialog;
var FlatButton = mui.FlatButton;
var injectTapEventPlugin = require("react-tap-event-plugin");
injectTapEventPlugin();

var FormMessageCenter = React.createClass({
  mixins: [MuiThemeMixin],
  getInitialState: function() {
    return {
      messageType: "",
      messageText: "",
    };
  },
  componentWillMount: function() {
    mediator.subscribe("MessageCenterDisplay", this.receiveDisplay);
    mediator.subscribe("MessageCenterDisplayAndFocus", this.receiveDisplayAndFocus);
  },

  receiveDisplay: function(type, message) {
    this.setState({
      messageType: message[0],
      messageText: message[1],
    });
    this.refs.errorDialog.show();
  },

  receiveDisplayAndFocus: function(type, message) {
    this.setState({
      messageType: message[0],
      messageText: message[1],
    });
    this.refs.errorDialog.show();
  },

  dismissMessage: function() {
    this.refs.errorDialog.dismiss();
  },

  customActions: function() {
    return [
      <FlatButton
        label="OK"
        primary={true}
        onTouchTap={this.dismissMessage}
      />
    ];
  },
  render: function () {
    return (
      <Dialog
        ref= "errorDialog"
        title={this.state.messageType}
        actions={this.customActions()}
        openImmediately = {false}
      >
        {this.state.messageText}
      </Dialog>
    );
  }
});
module.exports = FormMessageCenter;
