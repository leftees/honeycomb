var AppDispatcher = require("../dispatcher/AppDispatcher");
var EventEmitter = require("events").EventEmitter;
var CollectionActionTypes = require("../constants/CollectionActionTypes");
var CollectionStore = require('stores/Collection');

class MetadataConfigurationStore extends EventEmitter {
  constructor() {
    this._configuration = null;
    AppDispatcher.register(this.receiveAction.bind(this));
  }

  receiveAction(action) {

  }

  getAll() {
    if (this._configuration == null) {
      this.loadConfiguration();
    }

    return this._configuration;
  }

  getOptionalFields() {
    var fields = this.getAll();
    console.log(fields);
    return  _.reject(fields, function (field) { return !field.optionalFormField });
  }

  getDefaultFields() {
    var fields = this.getAll();
    return  _.reject(fields, function (field) { return !field.defaultFormField });
  }

  loadConfiguration() {
    var id = CollectionStore.id;
    var url = "/v1/collections/animals/metadata_configuration";

    $.ajax({
      url: url,
      dataType: "json",
      type: "GET",
      success: (function(data) {
        this._configuration = data.fields;
      }).bind(this),
      error: (function(xhr, status, err) {

      }).bind(this),
    });

  }
}

var metadataConfigurationStore = new MetadataConfigurationStore();
module.exports = metadataConfigurationStore;
