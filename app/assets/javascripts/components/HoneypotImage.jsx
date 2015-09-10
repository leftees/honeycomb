var React = require('react');
var HoneypotImage = React.createClass({
  mixins: [HoneypotImageMixin],

  getDefaultProps: function() {
    return {
      cssStyle: {},
    };
  },

  render: function() {
    return (<img src={this.src()} style={this.props.cssStyle} />)
  },
});
module.exports = HoneypotImage;
