//app/assets/javascripts/components/modal/Modal.jsx

var TextField = React.createClass({
  displayName: 'TextField',

  propTypes: {
    name: React.PropTypes.string.isRequired,
    title: React.PropTypes.string.isRequired,
    id: React.PropTypes.string.isRequired,
    value: React.PropTypes.string,
    required: React.PropTypes.string.isRequired,
    handleFieldChange: React.PropTypes.func.isRequired,
    placeholder: React.PropTypes.string,
    help: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      value: ""
    };
  },

  componentDidMount: function() {

  },

  requiredClass: function() {
    css = 'form-control'
    if (this.props.required) {
      css += ' required'
    }

    return css
  },

  handleChange: function(event) {
    this.props.handleFieldChange(this.props.id, event.target.value);
  },

  render: function () {
    return (
        <FormRow id={this.props.id} type="string" required={this.props.required} title={this.props.title} help={this.props.help} >
          <textarea name={this.props.name} className={this.requiredClass()} id={this.props.id} onChange={this.handleChange} placeholder={this.props.placeholder}>
            {this.props.value}
          </textarea>
        </FormRow>
      );
  }
});

