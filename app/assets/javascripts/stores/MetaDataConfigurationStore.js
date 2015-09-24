var AppDispatcher = require("../dispatcher/AppDispatcher");
var EventEmitter = require("events").EventEmitter;
var CollectionActionTypes = require("../constants/CollectionActionTypes");
var CollectionStore = require('stores/Collection');
var axios = require('axios');

class MetadataConfigurationStore extends EventEmitter {
  constructor() {
    this._configuration = null;
    this._optionalConfigurations = null;
    this._defaultConfigurations = null;

    AppDispatcher.register(this.receiveAction.bind(this));
  }

  receiveAction(action) {

  }

  getConfig() {
    // this maynot be completed
    return getAll(function () {});
  }

  getAll(succesFunction) {
    var id = CollectionStore.id;
    var url = "/v1/collections/animals/metadata_configuration";

    if (!this._promise) {
      this._promise = axios.get(url)
        .catch(function (response) {
          EventEmitter.emit("MessageCenterDisplay", "error", "Server Error");
        });
    }

    // add the then to the promise
    this._promise.then(function (response) {
      succesFunction(response.data.fields);
      return response;
    });

    return this._promise;
  }
}

var metadataConfigurationStore = new MetadataConfigurationStore();
module.exports = metadataConfigurationStore;
