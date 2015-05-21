//app/assets/javascripts/components/forms/ItemMetaDataForm.jsx

var ItemMetaDataForm = React.createClass({

  propTypes: {
    authenticityToken: React.PropTypes.string.isRequired,
    method: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired,
    url: React.PropTypes.string.isRequired,
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
      saved: false,
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
    if (!this.state.dirty) {
      return;
    }

    $.ajax({
      url: this.props.url,
      dataType: "json",
      type: "POST",
      data: this.postParams(),
      success: (function(data) {
        this.setSaved();
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
      errors: errors,
      saved: false,
    })
  },

  setDirty: function () {
    this.setState({
      dirty: true,
      saved: false,
    });
  },

  setSaved: function () {
    this.setState({
      dirty: false,
      errors: false,
      saved: true,
    });
  },

  unloadMsg: function (event) {
    if (this.state.dirty) {
      var confirmationMessage = "Caution - proceeding will cause you to lose any changes that are not yet saved. ";

      (event || window.event).returnValue = confirmationMessage;
      return confirmationMessage;
    }
  },

  formMsg: function () {
    if (this.state.errors) {
      return (<FormErrorMsg />);
    } else if (this.state.saved) {
      return (<FormSavedMsg />);
    }
    return "";
  },

  render: function () {
    return (
      <Panel PanelTitle="Meta Data">
        <Form id="meta_data_form" url={this.props.url} authenticityToken={this.props.authenticityToken} method={this.props.method} >
          {this.formMsg()}

          <StringField objectType={this.props.objectType} name="title" required={true} title="Title" value={this.state.formValues['title']} handleFieldChange={this.handleFieldChange} errorMsg={this.state.errors['title']} />
          <TextField objectType={this.props.objectType} name="description" title="Description" value={this.state.formValues['description']} handleFieldChange={this.handleFieldChange} errorMsg={this.state.errors['description']} placeholder="Example: &quot;Also known as 'La Giaconda' in Italian, this half-length portrait is one of the most famous paintings in the world. It is thought to depict Lisa Gherardini, the wife of Francesco del Giocondo.&quot;" />
          <TextField objectType={this.props.objectType} name="transcription" title="Transcription" value={this.state.formValues['transcription']} handleFieldChange={this.handleFieldChange} errorMsg={this.state.errors['transcription']}  />
          <StringField objectType={this.props.objectType} name="manuscript_url" title="Digitized Manuscript URL" value={this.state.formValues['manuscript_url']} handleFieldChange={this.handleFieldChange} placeholder="http://" help="Link to externally hosted manuscript viewer." errorMsg={this.state.errors['manuscript_url']}  />

          <SubmitButton formDirty={this.state.dirty} handleClick={this.handleSave} />
        </Form>
      </Panel>
    );
  }
});

