/** @jsx React.DOM */

var HoneypotImage = React.createClass({
  mixins: [HoneypotImageMixin],
  render: function() {
    return (<img src={this.src()} />)
  },
});
