//app/assets/javascripts/components/modal/Modal.jsx

var StringField = React.createClass({
  displayName: 'Form',

  propTypes: {
    name: React.PropTypes.string.isRequired,
    title: React.PropTypes.string.isRequired,
    id: React.PropTypes.string.isRequired,
    value: React.PropTypes.string.isRequired,
    required: React.PropTypes.string.isRequired,
    handleFieldChange: React.PropTypes.func.isRequired,
  },

  getDefaultProps: function() {
    return {
      method: "post",
      value: ""
    };
  },

  requiredClass: function() {
    if (this.props.required) {
      return 'required'
    }

    return ''
  },

  handleChange: function(event) {
    this.props.handleFieldChange(this.props.id, event.target.value);
  },

  cssClass: function() {
    {}
  },

  render: function () {
    return (
        <FormRow id={this.props.id} type="string" required={this.props.required} title={this.props.title}>
          <input type="text" name={this.props.name} value={this.props.value} className="{this.requiredClass()} form-control" id={this.props.id} onChange={this.handleChange} />
        </FormRow>
      );
  }
});

