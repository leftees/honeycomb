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
    defaultFields: React.PropTypes.array,
  },

  getDefaultProps: function() {
    return {
      method: "post",
      objectType: "item",
      menuIndex: 0,
      defaultFields: [ "name", "description", "creator" ],
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

  fieldDisplayed: function(field) {
    return (this.state.displayedFields[field] || this.props.defaultFields.indexOf(field) !== -1)
  },

  formFields: function() {
    var map_function = function(fieldConfig) {
      var field = fieldConfig.name;
      if (!this.fieldDisplayed(field)) {
        return "";
      }
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
          required={fieldConfig.required}
          help={fieldConfig.help} />
      );
    };

    map_function = _.bind(map_function, this);
    var defaultFields = _.map(this.state.defaultFormFields, map_function);
    var optionalFields = _.map(this.state.optionalFormFields, map_function);
    return defaultFields.concat(optionalFields);
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
    return (
      <Form id="meta_data_form" url={this.props.url} authenticityToken={this.props.authenticityToken} method={this.props.method} >
        <Panel>
          <PanelHeading>{this.state.formValues.name} Meta Data</PanelHeading>
          <PanelBody>

              { this.formFields() }

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
