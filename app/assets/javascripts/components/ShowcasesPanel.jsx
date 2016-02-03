var React = require('react');
var mui = require("material-ui");
var Avatar = mui.Avatar;

var ShowcasesPanel = React.createClass({
  mixins: [TitleConcatMixin, MuiThemeMixin],
  propTypes: {
    showcases: React.PropTypes.array.isRequired,
    panelTitle: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      showcases: [],
    };
  },

  showcaseImageDiv: function (showcase) {
    if(showcase.image) {
      return (
        <div className="image">
          <Avatar src={ showcase.image["thumbnail/small"]["contentUrl"] } />
        </div>
      )
    } else {
      return (
        <div className="image" >
          <Avatar>{ showcase.name_line_1[0].toUpperCase() }</Avatar>
        </div>
      )
    }
  },

  showcaseNameDiv: function (showcase) {
    return (
      <div className="name">
        { this.titleConcat(showcase.name_line_1, showcase.name_line_2) }
      </div>
    )
  },

  showcaseNodes: function () {
    if(this.props.showcases.length <= 0)
      return <p>This item is not in any showcases.</p>;

    return this.props.showcases.map(function(showcase, index) {
      key = "showcase-" + showcase.id;
      return (
        <div key={key} className="row">
          <a href={showcase["@id"]}>
            { this.showcaseImageDiv(showcase) }
            { this.showcaseNameDiv(showcase) }
          </a>
        </div>
      )
    }.bind(this));
  },

  embedPanel: function () {

    return (
      <Panel>
        <PanelHeading>{this.props.panelTitle}</PanelHeading>
        <PanelBody>
          <div className="info-panel">
            {this.showcaseNodes()}
          </div>
        </PanelBody>
      </Panel>
    )
  },

  render: function () {
    return (
      <div>
        {this.embedPanel()}
      </div>
    )
  }

});

module.exports = ShowcasesPanel;
