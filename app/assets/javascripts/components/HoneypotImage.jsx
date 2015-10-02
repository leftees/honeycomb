var React = require('react');
var HoneypotImage = React.createClass({
  mixins: [HoneypotImageMixin],

  getDefaultProps: function() {
    return {
      cssStyle: {},
      alt: "",
      title: "",
    };
  },

  render: function() {
    console.log(this.props)
    return (<img src={this.src()} style={this.props.cssStyle} title={this.props.title} alt={this.props.alt} />)
  },
});
module.exports = HoneypotImage;
