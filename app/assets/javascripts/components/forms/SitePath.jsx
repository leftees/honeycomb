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
    console.log(this.props.availableSiteObjects);
    return {
      availableSiteObjects: this.props.availableSiteObjects,
      orderedSiteObjects: this.props.orderedSiteObjects,
    };
  },

  addCard: function(listType, atIndex, siteObject) {
    if (listType == 'available') {
      this.setState(update(this.state, {
        availableSiteObjects: {
          $splice: [
            [atIndex, 0, siteObject],
          ]
        }
      }));
    } else if (listType == 'ordered') {
      this.setState(update(this.state, {
        orderedSiteObjects: {
          $splice: [
            [atIndex, 0, siteObject]
          ]
        }
      }));
    }
  },

  removeCard: function(listType, atIndex) {
    if (listType == 'available') {
      this.setState(update(this.state, {
        availableSiteObjects: {
          $splice: [
            [atIndex, 1],
          ]
        }
      }));
    } else if (listType == 'ordered') {
      this.setState(update(this.state, {
        orderedSiteObjects: {
          $splice: [
            [atIndex, 1]
          ]
        }
      }));
    }
  },

  moveCard: function(listType, fromIndex, toIndex, siteObject) {
    var removeIndex = fromIndex;
    if(toIndex < fromIndex) {
      removeIndex++;
    }
    if (listType == 'available') {
      this.setState(update(this.state, {
        availableSiteObjects: {
          $splice: [
            [toIndex, 0, siteObject],
            [removeIndex, 1],
          ]
        }
      }));
    } else if (listType == 'ordered') {
      this.setState(update(this.state, {
        orderedSiteObjects: {
          $splice: [
            [toIndex, 0, siteObject],
            [removeIndex, 1],
          ]
        }
      }));
    }
  },

  getCard: function(siteObject, index, listName){
    var name;
    var id = siteObject.object.id;
    switch(siteObject.type) {
      case "Showcase":
        name = siteObject.object.name_line_1;
        break;
      case "Page":
        name = siteObject.object.name;
        break;
      default:
        return;
        break;
    }
    var key = "available_site_object-" + id;
    return (<SiteObjectCard site_object={siteObject} id={id} key={key} index={index} addCard={this.addCard} moveCard={this.moveCard} removeCard={this.removeCard} site_object_name={name} site_object_list={listName} />)
  },

  render: function () {
    var ordered_site_objects = this.state.orderedSiteObjects.map(function (ordered_site_object, index) {
      return this.getCard(ordered_site_object, index, "ordered");
    }.bind(this));
    var available_site_objects = this.state.availableSiteObjects.map(function (available_site_object, index) {
      return this.getCard(available_site_object, index, "available");
    }.bind(this));

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
