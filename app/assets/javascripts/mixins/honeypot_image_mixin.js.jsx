/** @jsx React.DOM */

var HoneypotImageMixin = {
  propTypes: {
    honeypot_image: React.PropTypes.object.isRequired,
    style: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      style: 'original'
    };
  },

  src: function() {
    var imageObject;
    if (this.props.style != 'original') {
      imageObject = this.props.honeypot_image['thumbnail/' + this.props.style];
    }
    if (!imageObject) {
      imageObject = this.props.honeypot_image;
    }
    return imageObject.contentUrl;
  },
};
