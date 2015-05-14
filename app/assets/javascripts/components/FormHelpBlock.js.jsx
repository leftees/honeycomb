//app/assets/javascripts/components/modal/Modal.jsx

var FormHelpBlock = React.createClass({
  displayName: 'FormHelpBlock',

  propTypes: {
    children: React.PropTypes.oneOfType([
      React.PropTypes.object,
      React.PropTypes.array,
    ])
  },

  render: function () {
    return (
      <p class="help-block">{this.props.children}</p>
    );
  }
});
