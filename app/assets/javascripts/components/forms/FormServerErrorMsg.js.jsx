//app/assets/javascripts/components/forms/FormServerErrorMsg.jsx

var FormServerErrorMsg = React.createClass({
  propTypes: {
    message: React.PropTypes.string,
  },

  render: function () {
    var message = this.props.message || "The server has encountered an error.  The form has not been saved.";
    return (
      <div className="alert alert-danger" role="alert">
        {message}
      </div>
    );
  }
})
