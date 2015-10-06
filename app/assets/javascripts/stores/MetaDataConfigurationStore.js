var AppDispatcher = require("../dispatcher/AppDispatcher");
var EventEmitter = require("events").EventEmitter;
var CollectionStore = require("stores/Collection");
var axios = require("axios");

class MetadataConfigurationStore extends EventEmitter {
  constructor() {
    this._promise = null;
    AppDispatcher.register(this.receiveAction.bind(this));
  }

  receiveAction() {
    // held for use when actions are sent back to the object.
  }

  getAll(succesFunction) {
    var id = CollectionStore.uniqueId;
    var url = "/v1/collections/" + id + "/metadata_configuration";

    if (!this._promise) {
      this._promise = axios.get(url)
        .catch(function () {
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
