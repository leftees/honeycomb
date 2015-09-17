//app/assets/javascripts/components/forms/UploadFileField.jsx
var React = require('react');
var UploadFileField = React.createClass({

  propTypes: {
    objectType: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    title: React.PropTypes.string.isRequired,
    handleFieldChange: React.PropTypes.func.isRequired,
    required: React.PropTypes.bool,
    help: React.PropTypes.string,
    errorMsg: React.PropTypes.array,
  },

  getDefaultProps: function() {
    return {
      required: false,
    };
  },

  requiredClass: function() {
    var css = 'form-control';
    if (this.props.required) {
      css += ' required';
    }

    return css;
  },

  formName: function() {
    return this.props.objectType + "[" + this.props.name + "]";
  },

  formId: function() {
    return this.props.objectType + "_" + this.props.name;
  },

  render: function () {
    return (
      <FormRow id={this.formId()} type="string" required={this.props.required} title={this.props.title} help={this.props.help} errorMsg={this.props.errorMsg} >
        <input name={this.formName()} type="file" className={this.requiredClass()} id={this.formId()} />
      </FormRow>
    );
  }
});

module.exports = UploadFileField;
