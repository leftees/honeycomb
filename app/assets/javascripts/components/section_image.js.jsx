/** @jsx React.DOM */

var SectionImage = React.createClass({
  propTypes: {
    section: React.PropTypes.object.isRequired
  },

  style: function() {
    return {
      height: '100%',
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
      caption = (<div className="section-caption">{this.props.section.caption}</div>)
    }

    return (
      <div className="section-container section-container-image" style={this.style()}>
        <img src={this.props.section.image } style={this.imageStyle()} />
        { caption }
      </div>
    );
  }

});
