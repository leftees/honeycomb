/** @jsx React.DOM */

var ReactDropzone = React.createClass({
  propTypes: {
    formUrl: React.PropTypes.string.isRequired,
    authenticityToken: React.PropTypes.string.isRequired,
    multifileUpload: React.PropTypes.bool,
    modalTitle: React.PropTypes.string.isRequired,

  },

  getDefaultProps: function() {
    return {
      multifileUpload: true,
    };
  },

  getInitialState: function() {
    return { closed: false }
  },

  componentDidMount: function() {
    console.log(this.options());
    this.dropzone = new Dropzone(this.refs.uploadForm.getDOMNode(), this.options());
  },

  componentWillUnmount: function() {
    this.dropzone.destroy();
    this.dropzone = null;
  },

  options: function() {
    return {
      paramName: "item[image]",
      acceptedFiles: "image/*",
      addRemoveLinks: true,
      autoProcessQueue: true,
      url: this.props.formUrl,
      previewsContainer: ".dropzone-previews",
      clickable: ".dropzone",
      parallelUploads: 100,
      maxFiles: (this.multifileUpload ? 100 : 1),
      dictRemoveFile: "Cancel Upload",
      init: function () {
        this.on('addedfile', function () {
          this.element.classList.add("dz-started")
        });
      },
      complete: this.completeCallback,
    }
  },

  closeCallback: function(e) {
    if (this.dropzone.files.length > 0) {
      this.setState({closed: true});
      window.location.reload();
      e.preventDefault();
    }
  },

  completeCallback: function() {
    if (!this.props.multifileUpload) {
      $('#add-items').modal('hide');
    }
  },

  spinner: function () {
    if (this.state.closed) {
      return ( <LoadingImage /> );
    } else {
      return null;
    }
  },

  dropzoneForm: function() {
    if (!this.state.closed) {
      return (
        <form method="post" className="dropzone" ref="uploadForm" >
          <div>
            <input name="utf8" type="hidden" value="✓" />
            <input name="authenticity_token" type="hidden" value={this.props.authenticityToken} />
            { this.formMethod() }
          </div>
          <div className="dz-clickable">
            <div className="dropzone-previews"></div>
            <div className="dz-message">
              Drop files here or click to upload.
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
  render: function() {

    return (
      <Modal title={this.props.modalTitle} id="add-items" closeCallback={this.closeCallback} >
        { this.dropzoneForm() }
        { this.spinner() }
      </Modal>);
  }
});
