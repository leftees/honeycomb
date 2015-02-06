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
      return '/images/blank.png';
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
      <span className={this.classes()}><span className="hc-thumbnail-helper"></span><img src={this.thumbnailSrc()} className="hc-thumbnail-image"/></span>
    );
  }
});
