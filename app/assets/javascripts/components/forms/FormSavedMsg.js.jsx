//app/assets/javascripts/components/forms/FormSavedMsg.jsx
var React = require('react');
var FormSavedMsg = React.createClass({

  render: function () {
    return (
      <div className="alert alert-success" role="alert">
        Save Successful
      </div>
    );
  }
});

module.exports = FormSavedMsg;
