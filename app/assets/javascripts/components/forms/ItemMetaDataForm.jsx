/*jshint esnext: true */

//app/assets/javascripts/components/forms/ItemMetaDataForm.jsx
var React = require('react');
var mui = require("material-ui");
var DropDownMenu = mui.DropDownMenu;
var EventEmitter = require('../../EventEmitter');
var StringField = require('./StringField');
var DateField = require('./DateField');
var HtmlField = require('./HtmlField');
var TextField = require('./TextField');
var MultipleField = require('./MultipleField');
var MetadataConfigurationStore = require('../../stores/MetadataConfigurationStore');
var ItemMetaDataSelectAdditionalFields = require('./ItemMetaDataSelectAdditionalFields');

var fieldTypeMap = {
  string: StringField,
  date: DateField,
  html: HtmlField,
  text: TextField,
  multiple: MultipleField,
};

var ItemMetaDataForm = React.createClass({
  mixins: [MuiThemeMixin, APIResponseMixin],
  propTypes: {
    authenticityToken: React.PropTypes.string.isRequired,
    method: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired,
    url: React.PropTypes.string.isRequired,
    objectType: React.PropTypes.string,
    menuIndex: React.PropTypes.number,
  },

  getDefaultProps: function() {
    return {
      method: "post",
      objectType: "item",
      menuIndex: 0,
      additionalFieldConfiguration: {
        "creator": {"title": "Creator", "placeholder": 'Example "Leonardo da Vinci"', "type": "multiple", "help": ""},
        "contributor": {"title": "Contributor", "placeholder": '', "type": "multiple", "help": ""},
        "alternate_name": {"title": "Alternate Name", "placeholder": "An additional name this work is known as.", "type": "multiple", "help": ""},
        "rights": {"title": "Rights", "placeholder": 'Example "Copyright held by Hesburgh Libraries"', "type": "string", "help": ""},
        "provenance": {"title": "Provenance", "placeholder": 'Example: "Received as a gift from John Doe"', "type": "string", "help": ""},
        "call_number": {"title": "Call Number", "placeholder": '', "type": "string", "help": ""},
        "publisher": {"title": "Publisher", "placeholder": 'Example "Ballantine Books"', "type": "multiple", "help": ""},
        "subject": {"title": "Subject Keywords", "placeholder": '', "type": "string", "help": ""},
        "original_language": {"title": "Original Language", "placeholder": 'Example: "French"', "type": "string", "help": ""},
        "date_published": {"title": "Date Published", "placeholder": '', "type": "date", "help": ""},
        "date_modified": {"title": "Date Modified", "placeholder": '', "type": "date", "help": ""},
        "manuscript_url": {"title": "Digitized Manuscript URL", "placeholder": 'http://', "type": "string", "help": "Link to externally hosted manuscript viewer." },
      }
    };
  },

  getInitialState: function() {
    return {
      optionalFormFields: null,
      defaultFormFields: null,
      formValues: this.props.data,
      formState: "new",
      dataState: "clean",
      formErrors: false,
      responseCode: 0,
      displayedFields: _.mapObject(this.props.data, function(val, key) {
        if (val) {
          return true;
        }
        return false;
      }),
    };
  },

  componentDidMount: function() {
    window.addEventListener("beforeunload", this.unloadMsg);
  },

  componentWillUnmount: function() {
    window.removeEventListener("beforeunload", this.unloadMsg);
  },

  componentWillMount: function () {
    MetadataConfigurationStore.getOptionalFields(this.setOptionalFields);
    MetadataConfigurationStore.getDefaultFields(this.setDefaultFields);
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

  setServerError: function (errorString) {
    EventEmitter.emit("MessageCenterDisplay", "error", errorString);
    this.setState({
      formState: "error",
      formErrors: errorString,
    });
  },

  formDisabled: function () {
    return (this.state.dataState == "clean" || this.state.formState == "saveStarted");
  },

  unloadMsg: function (event) {
    if (this.state.dataState == "dirty") {
      var confirmationMessage = "Caution - proceeding will cause you to lose any changes that are not yet saved. ";

      (event || window.event).returnValue = confirmationMessage;
      return confirmationMessage;
    }
  },

  fieldError: function (field) {
    if (this.state.formErrors[field]) {
      return this.state.formErrors[field];
    }
    return [];
  },

  additionalFields: function() {
    var map_function = function(fieldConfig, index) {
      var field = fieldConfig.name;
      if (this.state.displayedFields[field]) {
        displayed_field_count = ++displayed_field_count;
        var FieldComponent = fieldTypeMap[fieldConfig.type];
        if (fieldConfig.multiple) {
          FieldComponent = MultipleField;
        }

        return (
          <FieldComponent
            key={field}
            objectType={this.props.objectType}
            name={field}
            title={fieldConfig.label}
            value={this.state.formValues[field]}
            handleFieldChange={this.handleFieldChange}
            errorMsg={this.fieldError(field)}
            placeholder={fieldConfig.placeholder}
            help={fieldConfig.help} />
        );
      }
      return "";
    };
    map_function = _.bind(map_function, this);
    var additional_fields = _.map(this.state.optionalFormFields, map_function);

    if (displayed_field_count == total_field_count) {
      return additional_fields;
    } else {
      return additional_fields.concat(dropdown_menu);
    }
  },

  changeAddField: function(event, selectedIndex, menuItem) {
    if (!menuItem.payload.field) {
      return;
    }

    this.state.displayedFields[menuItem.payload.field] = true;
    this.setState({
      displayedFields: this.state.displayedFields,
    });
  },

  setOptionalFields: function(optionalFields) {
    this.setState({ optionalFormFields: optionalFields });
  },

  setDefaultFields: function(defaultFields) {
    this.setState({ defaultFormFields: defaultFields });
  },

  render: function () {
    console.log(this.state);
    return (
      <Form id="meta_data_form" url={this.props.url} authenticityToken={this.props.authenticityToken} method={this.props.method} >
        <Panel>
          <PanelHeading>{this.state.formValues.name} Meta Data</PanelHeading>
          <PanelBody>
              <StringField objectType={this.props.objectType} name="name" required={true} title="Name" value={this.state.formValues.name} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('name')} />

              <HtmlField objectType={this.props.objectType} name="description" title="Description" value={this.state.formValues.description} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('description')} placeholder="Example: &quot;Also known as 'La Giaconda' in Italian, this half-length portrait is one of the most famous paintings in the world. It is thought to depict Lisa Gherardini, the wife of Francesco del Giocondo.&quot;" />

              <DateField objectType={this.props.objectType} name="date_created" title="Date Created" value={this.state.formValues.date_created} handleFieldChange={this.handleFieldChange} placeholder="" errorMsg={this.fieldError('date_created')} />

              <HtmlField objectType={this.props.objectType} name="transcription" title="Transcription" value={this.state.formValues.transcription} handleFieldChange={this.handleFieldChange} errorMsg={this.fieldError('transcription')}  />

              <ItemMetaDataSelectAdditionalFields
                displayedFields={this.state.displayedFields}
                selectableFields={this.state.optionalFormFields} />
          </PanelBody>
          <PanelFooter>
            <SubmitButton disabled={this.formDisabled()} handleClick={this.handleSave} />
          </PanelFooter>
        </Panel>
      </Form>
    );
  }
});

module.exports = ItemMetaDataForm;
