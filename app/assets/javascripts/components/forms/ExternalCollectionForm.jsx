//app/assets/javascripts/components/forms/ExternalCollectionForm.jsx
var React = require('react');
var EventEmitter = require('../../EventEmitter');
var StringField = require('./StringField');
var HtmlField = require('./HtmlField');
var TextField = require('./TextField');
var UploadFileField = require('./UploadFileField');

var fieldTypeMap = {
  string: StringField,
  html: HtmlField,
  text: TextField,
  upload: UploadFileField,
};

var ExternalCollectionForm = React.createClass({
  mixins: [MuiThemeMixin, APIResponseMixin],
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
    };
  },

  getInitialState: function() {
    return {
      formValues: this.props.data,
      formErrors: false,
      formState: "new",
      dataState: "clean",
      responseCode: 0,
    };
  },

  handleSave: function(event) {
    event.preventDefault();
    if (this.formDisabled()) {
      return;
    }

    $.ajax({
      url: this.props.url,
      dataType: "json",
      type: "POST",
      data: this.postParams(),
      success: (function(data) {
        this.setSavedSuccess();
      }).bind(this),
      error: (function(xhr, status, err) {
        if (xhr.status == "422") {
          this.setSavedFailure(xhr.responseJSON.errors);
        } else {
          this.setServerError(this.apiErrorToString(xhr));
        }
      }).bind(this),
    });
  },

  handleFieldChange: function(field, value) {
    this.state.formValues[field] = value;
    this.setState({
      formValues: this.state.formValues
    });
    this.setDirty();
  },

  postParams: function () {
    return ({
      utf8: "✓",
      _method: this.props.method,
      authenticity_token: this.props.authenticityToken,
      item: this.state.formValues,
    });
  },

  setSavedFailure: function (errors) {
    EventEmitter.emit("MessageCenterDisplay", "warning", "Unable to save the form.  Please correct the issues listed in the form and resave.");
    this.setState({
      formState: "invalid",
      formErrors: errors,
    });
  },

  setDirty: function () {
    this.setState({
      dataState: "dirty",
    });
  },

  setSavedStarted: function () {
    this.setState({
      formState: "saveStarted",
    });
  },

  setSavedSuccess: function () {
    EventEmitter.emit("MessageCenterDisplay", "success", "Item saved successfully.");
    this.setState({
      dataState: "clean",
      formState: "saved",
      formErrors: false,
    });
  },

  formDisabled: function () {
    return (this.state.dataState == "clean" || this.state.formState == "saveStarted");
  },

  fieldError: function (field) {
    if (this.state.formErrors[field]) {
      return this.state.formErrors[field];
    }
    return [];
  },


  render: function () {
    return (
      <Form id="external_collection_form" url={this.props.url} authenticityToken={this.props.authenticityToken} method={this.props.method} >
        <Panel>
          <PanelHeading>External Collection</PanelHeading>
          <PanelBody>
              <StringField objectType={this.props.objectType} name="name" required={true} title="Name" value={this.state.formValues.name} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('name')} />
              <StringField objectType={this.props.objectType} name="url" required={true} title="URL" value={this.state.formValues.url} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('url')} />
              <HtmlField objectType={this.props.objectType} name="description" title="Description" value={this.state.formValues.description} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('description')} placeholder="Example: This is an collection external to the honeycomb system" />
              <UploadFileField objectType={this.props.objectType} name="uploaded_image" title="Image" value={this.state.formValues.image} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('image')} />
          </PanelBody>
          <PanelFooter>
            <SubmitButton disabled={this.formDisabled()} handleClick={this.handleSave} />
          </PanelFooter>
        </Panel>
      </Form>
    );
  }
});

module.exports = ExternalCollectionForm;
