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
      htmlSafe: false,
    };
  },
  componentWillMount: function() {
    EventEmitter.on("MessageCenterDisplay", this.receiveDisplay);
  },

  receiveDisplay: function(messageType, messageText, htmlSafe) {
    this.setState({
      messageType: messageType,
      messageText: messageText,
      htmlSafe: htmlSafe,
    });
    this.refs.errorDialog.show();
  },

  dismissMessage: function() {
    this.refs.errorDialog.dismiss();
  },

  messageSpan: function() {
    if(this.state.htmlSafe) {
      return (<span dangerouslySetInnerHTML={{ __html: this.state.messageText }}></span>);
    } else {
      return (<span>{ this.state.messageText }</span>);
    }


  },

  render: function () {
    return (
      <Snackbar
        ref = "errorDialog"
        message={ this.messageSpan() }
      >
      </Snackbar>
    );
  }
});
module.exports = FormMessageCenter;
