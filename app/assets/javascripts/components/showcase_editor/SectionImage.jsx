/** @jsx React.DOM */
var React = require('react');
var SectionImage = React.createClass({
  propTypes: {
    section: React.PropTypes.object.isRequired
  },

  style: function() {
    return {
      height: '100%',
      display: 'inline-block',
      verticalAlign: 'top',
      position: 'relative',
    };
  },

  captionStyle: function() {
    return {
      backgroundColor: 'white',
      position: 'absolute',
      bottom: '2em',
      right: '1em',
      padding: '0.5em',
    };
  },

  imageStyle: function() {
    return {
      height: '100%',
    };
  },

  render: function () {
    var caption = "";
    if (this.props.section.caption) {
      caption = (<div className="section-caption" style={this.captionStyle()} dangerouslySetInnerHTML={{__html: this.props.section.caption}}/>)
    }

    return (
      <div className="section-container section-container-image" style={this.style()}>
        <img src={this.props.section.image } style={this.imageStyle()} />
        { caption }
      </div>
    );
  }

});
module.exports = SectionImage;
