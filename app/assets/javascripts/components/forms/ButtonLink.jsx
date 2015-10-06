/** @jsx React.DOM */
var React = require('react');
var mui = require("material-ui");
var RaisedButton = mui.RaisedButton;
var FontIcon = mui.FontIcon;

var ButtonLink = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    buttonLabel: React.PropTypes.string.isRequired,
    buttonLink: React.PropTypes.bool.isRequired,
    buttonUrl: React.PropTypes.string.isRequired,
    primaryFlag: React.PropTypes.bool.isRequired,
  },

  render: function() {
    var iconStyle = {fontSize: 14, marginRight: ".5em", color: "#fff"};
    var buttonStyle = {float: "right"}
    var buttonLabel = (
      <span style={ {"color": "#fff"} }>
        <FontIcon className="glyphicon glyphicon-plus" label={this.props.buttonLabel} style={iconStyle}/>
        {this.props.buttonLabel}
      </span>
    );
    return (
      <RaisedButton
        primary={this.props.primaryFlag}
        linkButton={this.props.buttonLink}
        href={this.props.buttonUrl}
        label={buttonLabel}
        style={buttonStyle}
        />
    );
  }
});

module.exports = ButtonLink;
