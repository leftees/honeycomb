var Thumbnail = React.createClass({
  propTypes: {
    image: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.object,
    ]),
  },

  getInitialState: function() {
    return {
      image: null,
    };
  },

  componentDidMount: function() {
    $.get(this.props.image, function(result) {
      this.setState({
        image: result,
      })
    }.bind(this));
  },

  thumbnailSrc: function() {
    if (this.state.image) {
      return this.state.image['thumbnail/small']['contentUrl'];
    } else {
      return '/images/ajax-loader.gif';
    }
  },

  classes: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'hc-thumbnail': true,
      'hc-thumbnail-loading': !this.state.image
    });
    return classes;
  },

  render: function() {
    return (
      <img src={this.thumbnailSrc()} className={this.classes()}/>
    );
  }
});
