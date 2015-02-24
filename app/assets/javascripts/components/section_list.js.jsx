/** @jsx React.DOM */

var SectionList = React.createClass({
  propTypes: {
    sections: React.PropTypes.array.isRequired,
    onSectionClick: React.PropTypes.func.isRequired,
    currentDragItem: React.PropTypes.object,
    onDrop: React.PropTypes.func.isRequired
  },
  sectionRows: function() {
    var rows, self;
    rows = [];
    self = this
    $.each(this.props.sections, function(idx, section) {
      rows.push(self.section_tag(section));
      rows.push(self.dropzone_tag(section.order))
    });

    if (rows.length === 0) {
      rows.push(this.dropzone_tag(0));
    }
    return rows;
  },
  section_tag: function(section) {
    var key = section.id + '-' + section.order
    return (<Section  onDragStart={this.props.onDragStart} onDragStop={this.props.onDragStop} section={section} key={key} onSectionClick={this.props.onSectionClick} />)
  },
  dropzone_tag: function(order) {
    var  key = "spacer-" + order;
    return (<NewSectionDropzone key={key} currentDragItem={this.props.currentDragItem} onDrop={this.props.onDrop} new_index={order + 1} />);
  },
  render: function() {
    return (<div id="sections-content-inner" className="sections-content-inner">{this.sectionRows()}</div>);
  }
});
