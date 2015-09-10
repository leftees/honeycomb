var React = require('react');
var LoadingImage = React.createClass({

  render: function () {
    return (<div className="loading"><img src="/images/ajax-loader.gif" /></div>)
  }
});
module.exports = LoadingImage;
