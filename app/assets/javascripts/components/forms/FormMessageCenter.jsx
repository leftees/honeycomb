var FormMessageCenter = React.createClass({
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
      return (<FormMessage message={this.state.messageText} type={this.state.messageType}/>);
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
})
