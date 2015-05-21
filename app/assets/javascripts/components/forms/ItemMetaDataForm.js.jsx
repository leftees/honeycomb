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
      formState: 'clean',
      formErrors: false,
    };
  },

  componentDidMount: function() {
    window.addEventListener("beforeunload", this.unloadMsg);
  },

  componentWillUnmount: function() {
    window.removeEventListener("beforeunload", this.unloadMsg);
  },

  handleSave: function(event) {
    event.preventDefault();
    if (this.formDisabled()) {
      return;
    }
    this.setSavedStarted();

    $.ajax({
      url: this.props.url,
      dataType: "json",
      type: "POST",
      data: this.postParams(),
      success: (function(data) {
        this.setSavedSuccess();
      }).bind(this),
      error: (function(xhr, status, err) {
        if (xhr.status == '422') {
          this.setSavedFailure(xhr.responseJSON.errors);
        } else {
          this.setServerError();
        }
      }).bind(this),
    });
  },

  handleFieldChange: function(field, value) {
    this.state.formValues[field] = value;
    this.setState({
      formValues: this.state.formValues
    })
    this.setDirty();
  },

  postParams: function () {
    return ({
      utf8: '✓',
      _method: this.props.method,
      authenticity_token: this.props.authenticityToken,
      item: this.props.data
    });
  },

  setSavedFailure: function (errors) {
    this.setState({
      formState: 'formErrors',
      formErrors: errors,
    })
  },

  setDirty: function () {
    this.setState({
      formState: 'dirty',
    });
  },

  setSavedStarted: function () {
    this.setState({
      formState: 'saveStarted',
    });
  },

  setSavedSuccess: function () {
    this.setState({
      formState: 'saved',
    });
  },

  setServerError: function () {
    this.setState({
      formState: 'serverError',
    });
  },


  formDisabled: function () {
    return (this.state.formState == 'clean' || this.state.formState == 'saved');
  },

  unloadMsg: function (event) {
    if (!this.formDisabled()) {
      var confirmationMessage = "Caution - proceeding will cause you to lose any changes that are not yet saved. ";

      (event || window.event).returnValue = confirmationMessage;
      return confirmationMessage;
    }
  },

  formMsg: function () {
    if (this.state.formState == 'formErrors') {
      return (<FormErrorMsg />);
    } else if (this.state.formState == 'saved') {
      return (<FormSavedMsg />);
    } else if (this.state.formState == 'serverError') {
      return (<FormServerErrorMsg />)
    }
    return "";
  },

  render: function () {
    return (
      <Panel PanelTitle="Meta Data">
        <Form id="meta_data_form" url={this.props.url} authenticityToken={this.props.authenticityToken} method={this.props.method} >
          {this.formMsg()}

          <StringField objectType={this.props.objectType} name="title" required={true} title="Title" value={this.state.formValues['title']} handleFieldChange={this.handleFieldChange} errorMsg={this.state.formErrors['title']} />
          <TextField objectType={this.props.objectType} name="description" title="Description" value={this.state.formValues['description']} handleFieldChange={this.handleFieldChange} errorMsg={this.state.formErrors['description']} placeholder="Example: &quot;Also known as 'La Giaconda' in Italian, this half-length portrait is one of the most famous paintings in the world. It is thought to depict Lisa Gherardini, the wife of Francesco del Giocondo.&quot;" />
          <TextField objectType={this.props.objectType} name="transcription" title="Transcription" value={this.state.formValues['transcription']} handleFieldChange={this.handleFieldChange} errorMsg={this.state.formErrors['transcription']}  />
          <StringField objectType={this.props.objectType} name="manuscript_url" title="Digitized Manuscript URL" value={this.state.formValues['manuscript_url']} handleFieldChange={this.handleFieldChange} placeholder="http://" help="Link to externally hosted manuscript viewer." errorMsg={this.state.formErrors['manuscript_url']}  />

          <SubmitButton disabled={this.formDisabled()} handleClick={this.handleSave} />
        </Form>
      </Panel>
    );
  }
});

