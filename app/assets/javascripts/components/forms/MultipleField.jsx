//app/assets/javascripts/components/forms/MultipleField.jsx
var React = require('react');
var MultipleField = React.createClass({

  propTypes: {
    objectType: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    title: React.PropTypes.string.isRequired,
    values: React.PropTypes.array,
    required: React.PropTypes.bool,
    handleFieldChange: React.PropTypes.func.isRequired,
    placeholder: React.PropTypes.string,
    help: React.PropTypes.string,
    errorMsg: React.PropTypes.array,
  },

  getInitialState: function() {
    return {
      values: [],
      currentValue: "",
      editValues: [],
      required: false,
    };
  },

  componentDidMount: function () {
    if (!this.props.value) {
      return;
    }
    this.setState({
      values: this.props.value,
    });
  },

  requiredClass: function() {
    var css = 'form-control';
    if (this.props.required) {
      css += ' required';
    }

    return css
  },

  updateValue: function(index, newValue) {
    if (this.state.values[index]) {
      this.state.values[index] = newValue;
      this.setState(this.state);
      this.props.handleFieldChange(this.props.name, this.state.values);
    }
  },

  handleChange: function(event) {
    this.state.currentValue = event.target.value;
    this.setState(this.state);
  },

  handleBlur: function(event) {
    if (this.state.currentValue) {
      this.state.values.push(this.state.currentValue);
      this.state.currentValue = "";

      this.props.handleFieldChange(this.props.name, this.state.values);
      React.findDOMNode(this.refs[this.formId()]).focus();
    }
  },

  handleRemove: function(index) {
    if (index > -1) {
      this.state.values.splice(index, 1);
      this.props.handleFieldChange(this.props.name, this.state.values);
    }
  },

  handleReplaceClick: function (index) {
    event.preventDefault();
    if (index > -1) {
      if (_.indexOf(this.state.editValues, index) != -1) {
        this.state.editValues.push(index);
      }
    }
  },

  handleKeyPress: function (event) {
    if (event.charCode == 13) {
      event.preventDefault();
      this.handleBlur(event);
    }
  },

  formName: function() {
    return this.props.objectType + "[" + this.props.name + "]";
  },

  formId: function() {
    return this.props.objectType + "_" + this.props.name;
  },

  displayValues: function () {
    return _.map(this.state.values, function (value, index) {
      return (<MultipleFieldDisplayValue key={index} value={value} index={index} handleFieldUpdate={this.updateValue} handleRemove={this.handleRemove} />)
    }, this);
  },

  render: function () {
    return (
      <FormRow id={this.formId()} type="string" required={this.props.required} title={this.props.title} help={this.props.help} errorMsg={this.props.errorMsg} >
        {this.displayValues()}
        <input type="text" ref={this.formId()} name={this.formName()} value={this.state.currentValue} className={this.requiredClass()} id={this.formId()} onChange={this.handleChange} placeholder={this.props.placeholder} onBlur={this.handleBlur}  onKeyPress={this.handleKeyPress} />
      </FormRow>
    );
  }
});
module.exports = MultipleField;
