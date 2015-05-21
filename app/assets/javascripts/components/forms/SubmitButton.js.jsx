//app/assets/javascripts/components/forms/SubmitButton.jsx

var SubmitButton = React.createClass({

  propTypes: {
    formDirty: React.PropTypes.string.isRequired,
    handleClick: React.PropTypes.func.isRequired,
    name: React.PropTypes.string,
    value: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      name: "save",
      value: "Save",
    };
  },

  buttonCSS: function () {
    var css = 'btn btn-primary';
    if (!this.props.formDirty) {
      css += ' disabled';
    }
    return css;
  },

  render: function () {
    return (<input type="submit" name={this.props.name} value={this.props.value} onClick={this.props.handleClick} className={this.buttonCSS()} />);
  }
});
