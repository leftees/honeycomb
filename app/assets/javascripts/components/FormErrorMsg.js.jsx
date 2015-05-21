//app/assets/javascripts/components/FormErrorMsg.jsx

var FormErrorMsg = React.createClass({
  displayName: 'FormErrorMsg',

  render: function () {
    return (
      <div className="alert alert-warning" role="alert">
        Please complete the highlighted fields in order to continue.
      </div>
    );
  }
})
