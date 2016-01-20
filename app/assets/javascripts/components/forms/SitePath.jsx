var React = require('react');
var ReactDOM = require('react-dom');
var update = require('react/lib/update');
var mui = require("material-ui");
var HTML5Backend = require('react-dnd-html5-backend');
var DragDropContext = require('react-dnd').DragDropContext;

var SitePath = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    availableSiteObjects: React.PropTypes.array,
    orderedSiteObjects: React.PropTypes.array
  },

  getInitialState: function() {
    return {
      availableSiteObjects: this.props.availableSiteObjects,
      orderedSiteObjects: this.props.orderedSiteObjects,
    };
  },

  moveCard: function(hoverIndex, listType, dragIndex) {
    if (listType == 'available') {
      this.setState(update(this.state, {
        availableSiteObjects: {
          $splice: [
            [dragIndex, 1],
            // [hoverIndex, 0, availableSiteObjects[dragIndex]]
          ]
        }
      }));
    } else if (listType == 'ordered') {
      this.setState(update(this.state, {
        orderedSiteObjects: {
          $splice: [
            [dragIndex, 1]
            // [hoverIndex, 0, orderedSiteObjects[dragIndex]]
          ]
        }
      }));
    }

    this.forceUpdate();
  },

  render: function () {
    var boundMoveCard = this.moveCard;
    var ordered_site_objects = this.state.orderedSiteObjects.map(function (ordered_site_object, index) {
      key = "ordered_site_object-" + ordered_site_object.id
      return <SiteObjectCard id={ordered_site_object.id} key={key} index={index} moveCard={boundMoveCard} site_object_name={ordered_site_object.name} site_object_list="ordered" />
    });
    var available_site_objects = this.state.availableSiteObjects.map(function (available_site_object, index) {
      key = "available_site_object-" + available_site_object.id
      return <SiteObjectCard id={available_site_object.id} key={key} index={index} moveCard={boundMoveCard} site_object_name={available_site_object.name} site_object_list="available"/>
    });

    return (
      <div id="site_path" className="dualpanel">
        <div className="list_panel">
          <span className="dd_list heading">Ordered</span>
          <OrderedSiteObjects>
            {ordered_site_objects}
          </OrderedSiteObjects>
        </div>
        <div className="list_panel">
          <span className="dd_list heading">Available</span>
          <AvailableSiteObjects>
            {available_site_objects}
          </AvailableSiteObjects>
        </div>
      </div>
    );
  }
});

module.exports = DragDropContext(HTML5Backend)(SitePath);
