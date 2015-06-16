//app/assets/javascripts/components/forms/FormErrorMsg.jsx

var FormErrorMsg = React.createClass({
  propTypes: {
    message: React.PropTypes.string,
  },

  render: function () {
    var message = this.props.message || "An unspecified error has occurred.";
    return (
      <div className="alert alert-warning" role="alert">
        {message}
      </div>
    );
  }
})
