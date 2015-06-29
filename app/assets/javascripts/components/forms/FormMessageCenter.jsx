var React = require("react");
var mediator = require("../../mediator");
var mui = require("material-ui");
var Dialog = mui.Dialog;

var FormMessageCenter = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],
  getInitialState: function() {
    return {
      messageType: "",
      messageText: "",
    };
  },
  componentWillMount: function() {
    mediator.subscribe("MessageCenterDisplay", this.receiveDisplay);
  },

  receiveDisplay: function(type, message) {
    this.setState({
      messageType: message[0],
      messageText: message[1],
    });
    this.refs.errorDialog.show();
  },

  dismissMessage: function() {
    this.refs.errorDialog.dismiss();
  },


  render: function () {
    return (
      <Dialog
        ref = "errorDialog"
        title = {this.state.messageType}
        actions = {this.okDismiss()}
      >
        {this.state.messageText}
      </Dialog>
    );
  }
});
module.exports = FormMessageCenter;
