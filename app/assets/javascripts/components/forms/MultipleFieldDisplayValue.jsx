//app/assets/javascripts/components/forms/MultipleField.jsx
var React = require('react');
var MultipleFieldDisplayValue = React.createClass({

  propTypes: {
    index: React.PropTypes.string.isRequired,
    value: React.PropTypes.string,
    handleFieldUpdate: React.PropTypes.func.isRequired,
    handleRemove: React.PropTypes.func.isRequired,
  },

  getInitialState: function() {
    return {
      editMode: false,
      value: "",
    };
  },

  componentDidMount: function() {
    this.setState({
      value: this.props.value,
    });
  },

  componentDidUpdate(){
    if (this.refs['input']) {
      var input = React.findDOMNode(this.refs['input']);
      var len = input.value.length;

      input.focus();
      input.setSelectionRange(len, len);
    }
  },

  handleChange: function(event) {
    this.setState( {
      value: event.target.value,
    })
  },

  handleRemove: function(event) {
    event.preventDefault();
    this.props.handleRemove(this.props.index);
  },

  handleClick: function (event) {
    event.preventDefault();
    this.state.editMode = true;
    this.setState(this.state);
  },

  handleBlur: function(event) {
    this.state.editMode = false;

    if (this.state.value) {
      this.props.handleFieldUpdate(this.props.index, this.state.value);
    } else {
      this.props.handleRemove(this.props.index);
    }
  },

  handleKeyPress: function(event) {
    if (event.charCode == 13) {
      this.handleBlur(event);
    }
  },

  renderDisplayElement: function() {
    if (this.state.editMode) {
      return (<input type="text" ref="input" className="form-control input-sm" onKeyPress={this.handleKeyPress} onBlur={this.handleBlur} onChange={this.handleChange} value={this.state.value} />);
    } else {
      return (this.props.value);
    }
  },

  render: function() {
    return (
      <div className="multi-field-value row" key={this.props.value}>
        <div className="col-xs-10 multi-field-value-cell" onClick={this.handleClick}>
          {this.renderDisplayElement()}
        </div>
        <div className="col-xs-2 multi-field-delete-cell">
          <a title="Remove this value" onClick={this.handleRemove}>| x</a>
        </div>
      </div>
    );
  }

});
module.exports = MultipleFieldDisplayValue;
