/** @jsx React.DOM */

var ShowcaseEditorTitle = React.createClass({
  propTypes: {
    showcase: React.PropTypes.object.isRequired,
  },

  getInitialState: function() {
    return {
      hover: false,
    };
  },

  onMouseEnter: function() {
    return this.setState({
      hover: true
    });
  },

  onMouseLeave: function() {
    return this.setState({
      hover: false
    });
  },

  style: function() {
    return {
      border: '1px solid lightgrey',
      display: 'inline-block',
      verticalAlign: 'top',
      position: 'relative',
      padding: '5px',
      height: '100%',
      marginRight: '10px',
    };
  },

  editTitle: function() {
    window.location = this.props.showcase.editUrl;
  },

  render: function() {
    var description;
    if (this.props.showcase.description) {
      var splitDescription = this.props.showcase.description.split(/[\n]+/);
      description = splitDescription.map(function(value, index) {
        return (
          <p key={index}>{value}</p>
        );
      });
    }
    return (
      <div className="showcase-title-page" style={this.style()} onMouseEnter={this.onMouseEnter} onMouseLeave={this.onMouseLeave}>
        <h2>{this.props.showcase.title}</h2>
        {description}
        <EditLink clickHandler={this.editTitle} visible={this.state.hover} />
      </div>
    );
  }
});
