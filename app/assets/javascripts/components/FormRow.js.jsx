//app/assets/javascripts/components/modal/Modal.jsx

var FormRow = React.createClass({
  displayName: 'Form',

  propTypes: {
    id: React.PropTypes.string.isRequired,
    children: React.PropTypes.oneOfType([
      React.PropTypes.object,
      React.PropTypes.array,
    ]).isRequired,
    type: React.PropTypes.string.isRequired,
    title: React.PropTypes.string.isRequired,
    required: React.PropTypes.string.isRequired
  },

  getDefaultProps: function() {
    return {
      method: "post",
    };
  },

  requiredClass: function() {
    if (this.props.required) {
      return 'required'
    }

    return ''
  },

  requiredStar: function() {
    if (this.props.required) {
      return (<abbr title="required">* </abbr>)
    }
    return ""
  },

  render: function () {
    return (
      <div className="form-group {this.props.type} {this.requiredClass()}">
        <label className="{this.props.type} {this.requiredClass()} control-label" for={this.props.id}>
          {this.requiredStar()}
          {this.props.title}
        </label>
        {this.props.children}
      </div>
    );
  }
});

