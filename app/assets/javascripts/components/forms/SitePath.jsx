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
  mixins: [MuiThemeMixin, APIResponseMixin],

  propTypes: {
    sitePathUpdateURL: React.PropTypes.string.isRequired,
    sitePathURL: React.PropTypes.string.isRequired,
    showcasesURL: React.PropTypes.string.isRequired,
    pagesURL: React.PropTypes.string.isRequired
  },

  getInitialState: function() {
    EventEmitter.on(SiteObjectEventTypes.CardDroppedOnTarget, this.handleDrop);
    EventEmitter.on(SiteObjectEventTypes.CardDroppedOnNothing, this.handleRemoveCard);
    return {
      availableSiteObjects: [],
      sitePathObjects: [],
    };
  },

  componentDidMount: function() {
    this.reload();
  },

  reload: function() {
    this.requestSitePath();
    this.requestShowcases();
    this.requestPages();
  },

  // Adds to state.availableSiteObjects excluding those that are in the site path
  addToAvailable: function(objects) {
    var filtered = objects.filter(function (object) {
      var found = this.state.sitePathObjects.filter(function(siteObject) {
        return object.id == siteObject.id
      }.bind(this));
      return found.length == 0;
    }.bind(this));
    var union = this.state.availableSiteObjects.concat(filtered);
    this.setState({
      availableSiteObjects: union
    });
  },

  requestSitePath: function() {
    $.get(this.props.sitePathURL, function(result) {
      console.log(result);
      if (this.isMounted()) {
        this.setState({
          sitePathObjects: result.site_objects
        });
      }
    }.bind(this));
  },

  requestShowcases: function() {
    $.get(this.props.showcasesURL, function(result) {
      if (this.isMounted()) {
        this.addToAvailable(result.showcases);
      }
    }.bind(this));
  },

  requestPages: function() {
    $.get(this.props.pagesURL, function(result) {
      console.log(result);
      if (this.isMounted()) {
        this.addToAvailable(result.pages);
      }
    }.bind(this));
  },

  pushChanges: function(){
    var json = this.state.sitePathObjects.map(function(object) {
      var type;
      switch(object.additionalType) {
        case "https://github.com/ndlib/honeycomb/wiki/Page":
          type = "Page";
          break;
        case "https://github.com/ndlib/honeycomb/wiki/Showcase":
          type = "Showcase";
          break;
      }
      return { type: type, unique_id: object.id };
    }.bind(this));

    $.ajax({
      url: this.props.sitePathUpdateURL,
      dataType: "json",
      data: {
        site_objects: JSON.stringify(json)
      },
      method: "PUT",
      success: (function() {

      }).bind(this),
      error: (function(xhr) {
        // Communicate the error to the user
        EventEmitter.emit("MessageCenterDisplay", "error", this.apiErrorToString(xhr));
      }).bind(this)
    });
  },

  handleRemoveCard: function(source){
    if(source.site_object_list == "ordered") {
      this.addCard("available", 0, source.site_object);
      this.removeCard(source.site_object_list, source.index);
    }
    if(source.site_object_list == "available") {
      this.addCard("ordered", this.state.sitePathObjects.length, source.site_object);
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
        sitePathObjects: {
          $splice: [
            [atIndex, 0, siteObject]
          ]
        }
      }), this.pushChanges);
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
        sitePathObjects: {
          $splice: [
            [atIndex, 1]
          ]
        }
      }), this.pushChanges);
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
        sitePathObjects: {
          $splice: [
            [toIndex, 0, siteObject],
            [removeIndex, 1],
          ]
        }
      }));
    }
  },

  getSiteCards: function() {
    return this.state.sitePathObjects.map(function (site_object, index) {
      return [
        <DropTarget className="site_object_expander" targetClassName="site_object_expander_target" expandedClassName="site_object_expander_expanded" data={{ site_object_list: "ordered", index: index }} />,
        <SiteObjectCard site_object={site_object} id={index} index={index} site_object_list="ordered" />
      ]
    }.bind(this));
  },

  getAvailableCards: function() {
    return this.state.availableSiteObjects.map(function (site_object, index) {
      return (<SiteObjectCard site_object={site_object} id={index} index={index} site_object_list="available" />);
    }.bind(this));
  },

  render: function () {
    return (
      <div id="site_path" className="dualpanel">
        <div className="list_panel">
          <mui.List subheader="Current Site Path">
            { this.getSiteCards() }
            <DropTarget className="site_object_expander_always_expanded" targetClassName="site_object_expander_target" expandedClassName="site_object_expander_expanded" data={{ site_object_list: "ordered", index: this.state.sitePathObjects.length }}/>
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
