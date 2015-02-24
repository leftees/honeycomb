/** @jsx React.DOM */

//= require showdown
var converter = new Showdown.converter()

var SectionDescription = React.createClass({
  propTypes: {
    section: React.PropTypes.object.isRequired
  },

  render: function () {
    var rawMarkup = false;
    if (this.props.section.description) {
      rawMarkup = this.props.section.description.toString();
    }

    if (rawMarkup) {
      return (<div className="section-container section-container-text">
        <h2>{this.props.section.title}</h2>
        <div className="section-description" dangerouslySetInnerHTML={{__html: rawMarkup}}  />
      </div>)
    } else {
      return (<div />)
    }
  }
});

