var React = require("react");
var mediator = require("../../mediator");
var mui = require("material-ui");
var Dialog = mui.Dialog;


var FormMessageCenter = React.createClass({
  mixins: [MuiThemeMixin],
  getInitialState: function() {
    return {
      messageType: "",
      messageText: "",
      displayState: "hidden",
    };
  },
  componentWillMount: function() {
    mediator.subscribe("MessageCenterDisplay", this.receiveDisplay);
    mediator.subscribe("MessageCenterHide", this.receiveHide);
    mediator.subscribe("MessageCenterFocus", this.receiveFocus);
    mediator.subscribe("MessageCenterDisplayAndFocus", this.receiveDisplayAndFocus);
  },

  receiveDisplay: function(type, message) {
    this.setState({
      displayState: "show",
      messageType: message[0],
      messageText: message[1],
    })
  },

  receiveDisplayAndFocus: function(type, message) {
    this.setState({
      displayState: "show",
      messageType: message[0],
      messageText: message[1],
    })
    this.getDOMNode().scrollIntoView();
  },

  receiveHide: function(type, message) {
    this.setState({
      displayState: "hidden"
    })
  },

  receiveFocus: function(type, message) {
    this.getDOMNode().scrollIntoView();
  },

  getMessage: function () {
    if(this.state.displayState == "show") {
      return (
      <Dialog
        openImmediately = {true}
      >
        {this.state.messageText}
      </Dialog>
      );
    }
    return "";
  },

  render: function () {
    if(this.state.displayState == "show") {
      return this.getMessage();
    } else {
      return <div/>
    }
  }
});
module.exports = FormMessageCenter;
