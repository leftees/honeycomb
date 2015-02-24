/** @jsx React.DOM */

var ImageCaptionEditor = React.createClass({
  getInitialState: function() {
    return {showForm: this.props.caption ? true : false };
  },
  handleClick: function() {
    this.setState({ showForm: !this.state.showForm });
  },
  editorStyle: function() {
    return {
      display: (this.state.showForm ? 'block' : 'none')
    }
  },
  render: function() {
    var text = this.state.showForm ? 'Hide' : 'Show';
    return (
      <div>
        <div className="image-caption-editor-toggle pull-right" onClick={this.handleClick}>
          {text} Caption
        </div>
        <div className="image-caption-editor-field" style={this.editorStyle()} >
          <textarea placeholder="Add Caption for Image" name={this.props.fieldName} className="form-control" rows="3" defaultValue={this.props.caption}></textarea>
        </div>

        <img src={this.props.image} width="100%" />
      </div>
    );
  }
});
