var AppDispatcher = require("../dispatcher/AppDispatcher");
var MetaDataConfigurationActionTypes = require("../constants/MetaDataConfigurationActionTypes");
var EventEmitter = require("../EventEmitter");
var APIResponseMixin = require("../mixins/APIResponseMixin");
var update = require('react-addons-update');

class MetaDataConfigurationActions {
  load(getUrl) {
    AppDispatcher.dispatch({
      actionType: MetaDataConfigurationActionTypes.MDC_LOAD,
      data: data
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

    $.ajax({
      url: pushToUrl,
      dataType: "json",
      method: "PUT",
      data: {
        fieldName: fieldName,
        fieldValues: fieldValues,
      },
      success: (function() {
        // Store was already changed, nothing to do here
        EventEmitter.emit("MessageCenterDisplay", "info", "Collection updated");
      }).bind(this),
      error: (function(xhr) {
        // Request to change failed, revert the store to previous values
        AppDispatcher.dispatch({
          actionType: MetaDataConfigurationActionTypes.MDC_CHANGE_FIELD,
          name: fieldName,
          values: previousValues,
        });
        // Communicate the error to the user
        EventEmitter.emit("MessageCenterDisplay", "error", APIResponseMixin.apiErrorToString(xhr));
      }).bind(this)
    });
  }
}

module.exports = new MetaDataConfigurationActions();
