/** @jsx React.DOM */

var ShowcaseEditor = React.createClass({
  mixins: [HorizontalScrollMixin],
  propTypes: {
    sectionsJSONPath: React.PropTypes.string.isRequired,
    sectionsPath: React.PropTypes.string.isRequired,
    itemsJSONPath: React.PropTypes.string.isRequired
  },
  getInitialState: function() {
    return {
      currentDragItem: null,
      currentDragType: null,
      sections: [],
      scroll: false
    };
  },
  loadSectionsFromServer: function() {
    $.ajax({
      url: this.props.sectionsJSONPath,
      dataType: "json",
      success: (function(data) {
        this.setState({
          sections: data.sections
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
      title: item.title,
      image: image,
      item_id: item.id,
      order: index
    };
    sections = this.state.sections;
    sections.splice(index, 0, section);
    return this.setState({
      sections: sections
    }, function() {
      $.ajax({
        url: this.props.sectionsJSONPath,
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
    sections = this.state.sections;
    sections.splice(index, 0, sections.splice(section.order, 1)[0]);
    //console.log(sections);
    this.setState({
      sections: sections
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
    window.location = "" + this.props.sectionsPath + "/" + section.id + "/edit";
  },
  render: function() {
    var divclassname;
    divclassname = "sections";
    if (this.state.currentDragItem) {
      divclassname = "sections dragging";
    }
    return (
    <div className={this.divclassname}>
      <h2>Sections</h2>
      <div id="section-content-editor" className="sections-content"  onMouseMove={this.onMouseMove} onMouseOut={this.onMouseOut} >
        <SectionList sections={this.state.sections} onSectionClick={this.sectionClick} currentDragItem={this.state.currentDragItem} onDrop={this.onDrop} onDragStart={this.onDragStart} onDragStop={this.onDragStop} />
      </div>
      <div className="add-items-content">
        <AddItemsBar onDragStart={this.onDragStart} onDragStop={this.onDragStop} itemsJSONPath={this.props.itemsJSONPath} />
      </div>
    </div>);
  }
});
