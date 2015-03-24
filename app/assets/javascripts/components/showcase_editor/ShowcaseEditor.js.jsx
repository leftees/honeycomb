/** @jsx React.DOM */

var ShowcaseEditor = React.createClass({
  mixins: [HorizontalScrollMixin],
  propTypes: {
    sectionsCreatePath: React.PropTypes.string.isRequired,
    showcaseJSONPath: React.PropTypes.string.isRequired,
    itemsJSONPath: React.PropTypes.string.isRequired
  },
  getInitialState: function() {
    return {
      currentDragItem: null,
      currentDragType: null,
      showcase: {sections: []},
      scroll: false
    };
  },
  loadSectionsFromServer: function() {
    $.ajax({
      url: this.props.showcaseJSONPath,
      dataType: "json",
      success: (function(data) {
        this.setState({
          showcase: data
        });
      }).bind(this),
      error: (function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }).bind(this)
    });
  },
  handleItemDrop: function(item, index) {
    var image, section, sections, style_path, honeypot_image;
    honeypot_image = item.links.image;
    if (honeypot_image['thumbnail/medium']) {
      image = honeypot_image['thumbnail/medium'].contentUrl;
    } else {
      image = honeypot_image.contentUrl;
    }

    section = {
      id: 'new',
      image: image,
      item_id: item.id,
      order: index
    };
    sections = this.state.showcase.sections;
    sections.splice(index, 0, section);
    return this.setState({
      sections: sections
    }, function() {
      $.ajax({
        url: this.props.sectionsCreatePath,
        dataType: "json",
        type: "POST",
        data: {
          section: section
        },
        success: (function(data) {
          this.loadSectionsFromServer();
        }).bind(this),
        error: (function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }).bind(this)
      });
    });
  },
  handleSectionReorder: function (section, index) {
    var currentIndex = _.findIndex(this.state.showcase.sections, function(listSection) {
      return listSection.id == section.id;
    });
    // Don't do anything if the section was dragged to the drop area immediately before or after its current location
    if (index < currentIndex || index > currentIndex + 1) {
      var update = React.addons.update;
      var newSection = update(section, {$merge: {order: index}});
      var splicedSections;
      if (currentIndex < index) {
        splicedSections = update(this.state.showcase.sections, {$splice: [[newSection.order, 0, newSection], [currentIndex, 1]]});
      } else {
        splicedSections = update(this.state.showcase.sections, {$splice: [[currentIndex, 1], [newSection.order, 0, newSection]]});
      }
      this.setState({
        sections: splicedSections
      });
      this.updateSection(newSection);
    }
  },
  updateSection: function (section) {
    $.ajax({
      url: section.updateUrl,
      dataType: "json",
      type: "POST",
      data: {
        section: section,
        "_method": "put"
      },
      success: (function(data) {
        this.loadSectionsFromServer();
      }).bind(this),
      error: (function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }).bind(this)
    });
  },
  onDragStart: function(details, drag_type) {
    return this.setState({
      currentDragItem: details,
      currentDragType: drag_type
    });
  },
  onDragStop: function() {
    return this.setState({
      currentDragItem: null,
      currentDragType: null
    });
  },
  onDrop: function(target, index) {
    if (this.state.currentDragType == 'new_item') {
      this.handleItemDrop(target, index);
    } else if (this.state.currentDragType =='reorder') {
      this.handleSectionReorder(target, index)
    }
    return this.setState({
      lastDrop: {
        source: this.state.currentDragItem,
        target: target
      }
    });
  },
  onMouseMove: function(event) {
    if (!this.state.currentDragItem) {
      if (this.state.scroll) {
        this.setState( { scroll: false } );
      }
      return
    }
    this.setHorizontalScrollOnElement('section-content-editor', 40);

  },
  componentDidMount: function() {
    this.loadSectionsFromServer();
    setTimeout(this.loadSectionsFromServer, 8000);
  },
  sectionClick: function(section) {
    window.location = section.editUrl;
  },
  sectionsContainerStyle: function() {
    return {
      position: 'relative',
      overflowY: 'hidden',
      overflowX: 'scroll',
      whiteSpace: 'nowrap',
      boxSizing: 'border-box',
      height: '500px',
      top: 0,
      left: 0,
      border: '1px solid #bed5cd',
      padding: '10px',
      marginBottom: '2em',
    };
  },

  render: function() {
    var divclassname;
    divclassname = "sections";
    if (this.state.currentDragItem) {
      divclassname = "sections dragging";
    }
    return (
    <div className={this.divclassname}>
      <div id="section-content-editor" className="sections-content"  onMouseMove={this.onMouseMove} onMouseOut={this.onMouseOut} style={this.sectionsContainerStyle()}>
        <ShowcaseEditorTitle showcase={this.state.showcase} />
        <SectionList sections={this.state.showcase.sections} onSectionClick={this.sectionClick} currentDragItem={this.state.currentDragItem} onDrop={this.onDrop} onDragStart={this.onDragStart} onDragStop={this.onDragStop} />
      </div>
      <AddItemsBar onDragStart={this.onDragStart} onDragStop={this.onDragStop} itemsJSONPath={this.props.itemsJSONPath} />
    </div>);
  }
});
