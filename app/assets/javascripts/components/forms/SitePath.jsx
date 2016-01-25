var React = require('react');
var ReactDOM = require('react-dom');
var update = require('react/lib/update');
var mui = require("material-ui");
var HTML5Backend = require('react-dnd-html5-backend');
var DragDropContext = require('react-dnd').DragDropContext;
var EventEmitter = require('../../EventEmitter');
var SiteObjectEventTypes = require("./SiteObjectEventTypes");
var DropTarget = ExpandingDropTarget(SiteObjectEventTypes.DnDMessage);

var SitePath = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    availableSiteObjects: React.PropTypes.array,
    orderedSiteObjects: React.PropTypes.array
  },

  getInitialState: function() {
    EventEmitter.on(SiteObjectEventTypes.CardDroppedOnTarget, this.handleDrop);
    EventEmitter.on(SiteObjectEventTypes.CardDroppedOnNothing, this.handleRemoveCard);
    return {
      availableSiteObjects: this.props.availableSiteObjects,
      orderedSiteObjects: this.props.orderedSiteObjects,
    };
  },

  handleRemoveCard: function(source){
    if(source.site_object_list == "ordered") {
      this.addCard("available", 0, source.site_object);
      this.removeCard(source.site_object_list, source.index);
    }
    if(source.site_object_list == "available") {
      this.addCard("ordered", this.state.orderedSiteObjects.length, source.site_object);
      this.removeCard(source.site_object_list, source.index);
    }
  },

  handleDrop: function(target, source) {
    // Reorder within same list
    if(target.site_object_list == source.site_object_list) {
      if(source.index == target.index){
        return;
      }
      this.moveCard(target.site_object_list, source.index, target.index, source.site_object);
    } else {
      // Move card from one list to another
      this.addCard(target.site_object_list, target.index, source.site_object);
      this.removeCard(source.site_object_list, source.index);
    }
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

  getSiteCards: function() {
    return this.state.orderedSiteObjects.map(function (ordered_site_object, index) {
      return [
        <DropTarget className="site_object_expander" targetClassName="site_object_expander_target" expandedClassName="site_object_expander_expanded" data={{ site_object_list: "ordered", index: index }} />,
        <SiteObjectCard site_object={ordered_site_object} id={index} index={index} site_object_list="ordered" />
      ]
    }.bind(this));
  },

  getAvailableCards: function() {
    return this.state.availableSiteObjects.map(function (available_site_object, index) {
      return (<SiteObjectCard site_object={available_site_object} id={index} index={index} site_object_list="available" />);
    }.bind(this));
  },

  render: function () {
    return (
      <div id="site_path" className="dualpanel">
        <div className="list_panel">
          <mui.List subheader="Current Site Path">
            { this.getSiteCards() }
            <DropTarget className="site_object_expander_always_expanded" targetClassName="site_object_expander_target" expandedClassName="site_object_expander_expanded" data={{ site_object_list: "ordered", index: this.state.orderedSiteObjects.length }}/>
          </mui.List>
        </div>
        <div className="list_panel">
          <mui.List subheader="Available Pages and Showcases">
            { this.getAvailableCards() }
          </mui.List>
        </div>
      </div>
    );
  }
});

module.exports = DragDropContext(HTML5Backend)(SitePath);
