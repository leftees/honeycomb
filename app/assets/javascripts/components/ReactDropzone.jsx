/** @jsx React.DOM */
var Dropzone = require("../dropzone");
Dropzone.autoDiscover = false;
var React = require('react');
var mui = require("material-ui");
var Dialog = mui.Dialog;
var RaisedButton = mui.RaisedButton;
var FontIcon = mui.FontIcon;

var ReactDropzone = React.createClass({
  mixins: [MuiThemeMixin, DialogMixin],

  propTypes: {
    formUrl: React.PropTypes.string.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    multifileUpload: React.PropTypes.bool,
    modalTitle: React.PropTypes.string.isRequired,
    doneText: React.PropTypes.string,
    cancelText: React.PropTypes.string,
    modalId: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      multifileUpload: true,
      closeText: 'Close',
      modalId: "add-items",
    };
  },

  getInitialState: function() {
    return {
      closed: false,
      hasFiles: false,
    };
  },

  componentDidMount: function() {
    if (!this.dropzone) {
      this.dropzone = new Dropzone(this.refs.uploadForm.getDOMNode(), this.options());
      this.dropzone.on('addedfile', this.checkfileCallback);
      this.dropzone.on('removedfile', this.checkfileCallback);
    }
  },

  componentWillUnmount: function() {
    this.dropzone.destroy();
    this.dropzone = null;
  },

  options: function() {
    return {
      paramName: "item[uploaded_image]",
      acceptedFiles: "image/*",
      addRemoveLinks: true,
      autoProcessQueue: true,
      url: this.props.formUrl,
      previewsContainer: "#dz-preview-" + this.props.modalId,
      clickable: "#dz-" + this.props.modalId,
      parallelUploads: 100,
      maxFiles: (this.props.multifileUpload ? 100 : 1),
      dictRemoveFile: "Cancel Upload",
      someprop: "prop",
      complete: this.completeCallback,
    };
  },

  closeCallback: function(e) {
    if (this.dropzone.files.length > 0) {
      this.setState({closed: true});
      window.location.reload();
      e.preventDefault();
    }
  },
  dismissMessage: function() {
    this.refs.addItems.dismiss();
  },

  completeCallback: function() {
    if (!this.props.multifileUpload) {
      $("#" + this.props.modalId).modal('hide');
    }
  },

  checkfileCallback: function () {
    var hasFiles = (this.dropzone.files.length > 0);
    this.setState( { hasFiles: hasFiles } );
  },

  spinner: function () {
    if (this.state.closed) {
      return ( <LoadingImage /> );
    } else {
      return null;
    }
  },

  classes: function () {
    var classes = "dropzone"
    if (this.dropzone && this.dropzone.files.length > 0) {
      classes += " dz-started";
    }
    return classes;
  },

  dropzoneForm: function() {
    if (!this.state.closed) {
      return (
        <form method="post" className={this.classes()} ref={"uploadForm"} id={"dz-" + this.props.modalId}>
          <div>
            <input name="utf8" type="hidden" value="✓" />
            <input name="authenticity_token" type="hidden" value={this.props.authenticityToken} />
            { this.formMethod() }
          </div>
          <div className="dz-clickable" onDrop={this.droppedCallback} >
            <div className="dropzone-previews" id={"dz-preview-" + this.props.modalId}></div>
            <div className="dz-message">
              <h4>Drag images here</h4>
              <p>or <br /> <a className="btn btn-raised">Select images from your computer.</a></p>
            </div>
          </div>
        </form>
        )
    } else {
      return null;
    }
  },

  formMethod: function() {
    if (!this.props.multifileUpload) {
      return (<input name="_method" type="hidden" value="put" />)
    } else {
      return null
    }
  },

  closeText: function () {
    if (this.state.hasFiles) {
      return this.props.doneText;
    }

    return this.props.cancelText;
  },

  showModal: function() {
    this.refs.addItems.show();
  },

  render: function() {
    var iconStyle = {fontSize: 14, marginRight: ".5em"};
    var buttonLabel = (
      <span>
        <FontIcon className="glyphicon glyphicon-plus" label="Add New Items" color="#fff" style={iconStyle}/>
        <span>Add New Items</span>
      </span>
    );
    return (
      <div>
        <RaisedButton
          primary={true}
          onTouchTap={this.showModal}
          label={buttonLabel}
        />
        <Dialog
          ref="addItems"
          title={this.props.modalTitle}
          actions={this.okDismiss()}
          openImmediately={false}
        >
          { this.dropzoneForm() }
          { this.spinner() }
        </Dialog>
      </div>
    );
  }
});
module.exports = ReactDropzone;
