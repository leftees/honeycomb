var React = require('react');
var mui = require("material-ui");
var Avatar = mui.Avatar;

var PagesPanel = React.createClass({
  mixins: [TitleConcatMixin, MuiThemeMixin],
  propTypes: {
    pages: React.PropTypes.array.isRequired,
    panelTitle: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      pages: [],
    };
  },

  pageImageDiv: function (page) {
    if(page.image) {
      return (
        <div className="image">
          <Avatar src={ page.image["thumbnail/small"]["contentUrl"] } />
        </div>
      )
    } else {
      return (
        <div className="image" >
          <Avatar>{ "P" }</Avatar>
        </div>
      )
    }
  },

  pageNameDiv: function (page) {
    return (
      <div className="name">
        { this.titleConcat(page.name) }
      </div>
    )
  },

  pageNodes: function () {
    if(this.props.pages.length <= 0)
      return <p>This item is not in any pages.</p>;

    return this.props.pages.map(function(page, index) {
      key = "page-" + page.id;
      return (
        <div key={key} className="row">
          <a href={page["@id"]}>
            { this.pageImageDiv(page) }
            { this.pageNameDiv(page) }
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
            {this.pageNodes()}
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

module.exports = PagesPanel;
