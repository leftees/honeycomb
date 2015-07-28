var AppDispatcher = require("../dispatcher/AppDispatcher");
var CollectionActionTypes = require("../constants/CollectionActionTypes");
var EventEmitter = require("../EventEmitter");
var APIResponseMixin = require("../mixins/APIResponseMixin");

class CollectionActions {
  setState(collection) {
    AppDispatcher.dispatch({
      actionType: CollectionActionTypes.COL_SET_STATE,
      collection: collection
    });
  }

  setPublished(enabled) {
    AppDispatcher.dispatch({
      actionType: CollectionActionTypes.COL_CHANGE_PUBLISHED,
      enabled: enabled
    });
  }

  changePublished(enabled, pushToUrl) {
    // Optimistically change the store
    this.setPublished(enabled);

    $.ajax({
      url: pushToUrl,
      dataType: "json",
      method: "PUT",
      success: (function() {
        // Tell the store that the previous change went through
        AppDispatcher.dispatch({actionType: CollectionActionTypes.COL_CHANGE_PUBLISHED_FINALIZE });
      }).bind(this),
      error: (function(xhr) {
        // Tell the store that the previous change failed and it should revert
        AppDispatcher.dispatch({ actionType: CollectionActionTypes.COL_CHANGE_PUBLISHED_REVERT });
        // Communicate the error to the user
        EventEmitter.emit("MessageCenterDisplay", "error", APIResponseMixin.apiErrorToString(xhr));
      }).bind(this)
    });
  }

  setPreview(enabled) {
    // Optimistically change the store
    AppDispatcher.dispatch({
      actionType: CollectionActionTypes.COL_CHANGE_PREVIEW,
      enabled: enabled
    });
  }

  changePreview(enabled, pushToUrl) {
    // Optimistically change the store
    this.setPreview(enabled);

    $.ajax({
      url: pushToUrl,
      dataType: "json",
      data: {
        value: enabled
      },
      method: "PUT",
      success: (function() {
        // Tell the store that the previous change went through
        AppDispatcher.dispatch({actionType: CollectionActionTypes.COL_CHANGE_PREVIEW_FINALIZE });
      }).bind(this),
      error: (function(xhr) {
        // Tell the store that the previous change failed and it should revert
        AppDispatcher.dispatch({actionType: CollectionActionTypes.COL_CHANGE_PREVIEW_REVERT });
        // Communicate the error to the user
        EventEmitter.emit("MessageCenterDisplay", "error", APIResponseMixin.apiErrorToString(xhr));
      }).bind(this)
    });

  }
}

module.exports = new CollectionActions();
