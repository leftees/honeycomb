var AppDispatcher = require("../dispatcher/AppDispatcher");
var MetaDataConfigurationActionTypes = require("../constants/MetaDataConfigurationActionTypes");
var AppEventEmitter = require("../EventEmitter");
var NodeEventEmitter = require("events").EventEmitter;
var APIResponseMixin = require("../mixins/APIResponseMixin");
var update = require("react-addons-update");

class MetaDataConfigurationActions extends NodeEventEmitter {
  changeActive(fieldName, activeValue, pushToUrl){
    // Clone values in order to revert the store if the change fails
    const previousValue = MetaDataConfigurationStore.fields[fieldName].active;
    var fieldValues = update(MetaDataConfigurationStore.fields[fieldName], {});

    // Optimistically change the store
    fieldValues["active"] = activeValue;
    AppDispatcher.dispatch({
      actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FIELD,
      name: fieldName,
      values: fieldValues,
    });

    pushToUrl += "/" + fieldName;
    $.ajax({
      url: pushToUrl,
      dataType: "json",
      method: "PUT",
      data: {
        fields: fieldValues,
      },
      success: (function() {
        // Store was already changed, nothing to do here
        this.emit("ChangeActiveFinished", true);
        AppEventEmitter.emit("MessageCenterDisplay", "info", "Collection updated");
      }).bind(this),
      error: (function(xhr) {
        // Request to change failed, revert the store to previous values
        fieldValues["active"] = previousValue;
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FIELD,
          name: fieldName,
          values: fieldValues,
        });
        // Communicate the error to the user
        this.emit("ChangeActiveFinished", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", APIResponseMixin.apiErrorToString(xhr));
      }).bind(this)
    });
  }

  changeField(fieldName, fieldValues, pushToUrl) {
    // Clone values in order to revert the store if the change fails
    const previousValues = update(MetaDataConfigurationStore.fields[fieldName], {});
    // Optimistically change the store
    AppDispatcher.dispatch({
      actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FIELD,
      name: fieldName,
      values: fieldValues,
    });

    pushToUrl += "/" + fieldName;
    $.ajax({
      url: pushToUrl,
      dataType: "json",
      method: "PUT",
      data: {
        fields: fieldValues,
      },
      success: (function() {
        // Store was already changed, nothing to do here
        this.emit("ChangeFieldFinished", true);
        AppEventEmitter.emit("MessageCenterDisplay", "info", "Collection updated");
      }).bind(this),
      error: (function(xhr) {
        // Request to change failed, revert the store to previous values
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FIELD,
          name: fieldName,
          values: previousValues,
        });
        // Communicate the error to the user
        this.emit("ChangeFieldFinished", false, xhr);
        AppEventEmitter.emit("MessageCenterDisplay", "error", APIResponseMixin.apiErrorToString(xhr));
      }).bind(this)
    });
  }
}

module.exports = new MetaDataConfigurationActions();
