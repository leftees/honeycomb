//app/assets/javascripts/components/modal/Modal.jsx

var ItemMetaDataForm = React.createClass({
  displayName: 'ItemMetaDataForm',

  propTypes: {
    authenticityToken: React.PropTypes.string.isRequired,
    method: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired,
    errors: React.PropTypes.object,
    url: React.PropTypes.string.isRequired,
    returnUrl: React.PropTypes.string.isRequired,
    objectType: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      method: "post",
      objectType: "item",
    };
  },

  getInitialState: function() {
    return {
      formValues: this.props.data,
      errors: false,
      dirty: false,
    }
  },

  componentDidMount: function() {
    window.addEventListener("beforeunload", this.unloadMsg);
  },

  componentWillUnmount: function() {
    window.removeEventListener("beforeunload", this.unloadMsg);
  },

  handleSave: function(event) {
    event.preventDefault();

    $.ajax({
      url: this.props.url,
      dataType: "json",
      type: "POST",
      data: this.postParams(),
      success: (function(data) {
        this.cleanForm();
        alert("You did it! Item SAVED. ");
      }).bind(this),
      error: (function(xhr, status, err) {
        if (xhr.status == '422') {
          this.setErrors(xhr.responseJSON);
        } else {
          console.error(this.props.url, status, err.toString());
        }
      }).bind(this)
    });
  },

  handleFieldChange: function(field, value) {
    this.state.formValues[field] = value;
    this.setState({
      formValues: this.state.formValues
    })
    this.setDirty()
  },

  postParams: function () {
    return ({
      utf8: '✓',
      _method: this.props.method,
      authenticity_token: this.props.authenticityToken,
      item: this.props.data
    });
  },

  setErrors: function (errors) {
    this.setState({
      errors: errors
    })
  },

  setDirty: function () {
    this.setState({
      dirty: true,
    });
  },

  cleanForm: function () {
    this.setState({
      dirty: false,
      errors: false,
    });
  },

  unloadMsg: function (event) {
    if (this.state.dirty) {
      var confirmationMessage = "Caution - proceeding will cause you to lose any changes that are not yet saved. ";

      (event || window.event).returnValue = confirmationMessage;
      return confirmationMessage;
    }
  },

  hasErrors: function () {
    if (this.state.errors) {
      return true;
    }
    return false;
  },

  render: function () {
    return (
      <Panel PanelTitle="Meta Data">
        <Form id="meta_data_form" url={this.props.url} authenticityToken={this.props.authenticityToken} method={this.props.method} hasErrors={this.hasErrors()}>

          <StringField objectType={this.props.objectType} name="title" required={true} title="Title" value={this.state.formValues['title']} handleFieldChange={this.handleFieldChange} errorMsg={this.state.errors['title']} />
          <TextField objectType={this.props.objectType} name="description" title="Description" value={this.state.formValues['description']} handleFieldChange={this.handleFieldChange} errorMsg={this.state.errors['description']} placeholder="Example: &quot;Also known as 'La Giaconda' in Italian, this half-length portrait is one of the most famous paintings in the world. It is thought to depict Lisa Gherardini, the wife of Francesco del Giocondo.&quot;" />
          <TextField objectType={this.props.objectType} name="transcription" title="Transcription" value={this.state.formValues['transcription']} handleFieldChange={this.handleFieldChange} errorMsg={this.state.errors['transcription']}  />
          <StringField objectType={this.props.objectType} name="manuscript_url" title="Digitized Manuscript URL" value={this.state.formValues['manuscript_url']} handleFieldChange={this.handleFieldChange} placeholder="http://" help="Link to externally hosted manuscript viewer." errorMsg={this.state.errors['manuscript_url']}  />

          <input type="submit" value="save" onClick={this.handleSave} className="btn btn-primary" />
        </Form>
      </Panel>
    );
  }
});

