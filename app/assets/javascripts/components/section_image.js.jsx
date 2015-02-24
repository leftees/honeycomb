/** @jsx React.DOM */

var SectionImage = React.createClass({
  propTypes: {
    section: React.PropTypes.object.isRequired
  },

  render: function () {
    var caption = "";
    if (this.props.section.caption) {
      caption = (<div className="section-caption">{this.props.section.caption}</div>)
    }

    return (<div className="section-container section-container-image">
      <img src={this.props.section.image } />
      { caption }
    </div>)
  }

});
