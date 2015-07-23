var AppDispatcher = require("../dispatcher/AppDispatcher");
var EventEmitter = require("events").EventEmitter;
var CollectionActionTypes = require("../constants/CollectionActionTypes");

class CollectionStore extends EventEmitter {
  constructor() {
    this.title = "";
    this.preview = false;
    this.published = false;
    this.openChanges = [];

    AppDispatcher.register(this.receiveAction.bind(this));
  }

  // Receives actions sent by the AppDispatcher
  receiveAction(action) {
    switch(action.actionType) {
      case CollectionActionTypes.COL_SET_STATE:
        this.setProps(action.collection);
        break;
      case CollectionActionTypes.COL_CHANGE_PUBLISHED:
        this.change("published", action.enabled);
        break;
      case CollectionActionTypes.COL_CHANGE_PUBLISHED_FINALIZE:
        this.save("published");
        break;
      case CollectionActionTypes.COL_CHANGE_PUBLISHED_REVERT:
        this.revert("published");
        break;
      case CollectionActionTypes.COL_CHANGE_PREVIEW:
        this.change("preview", action.enabled);
        break;
      case CollectionActionTypes.COL_CHANGE_PREVIEW_FINALIZE:
        this.save("preview");
        break;
      case CollectionActionTypes.COL_CHANGE_PREVIEW_REVERT:
        this.revert("preview");
        break;
      case CollectionActionTypes.COL_CHANGE_TITLE:
        this.change("title", action.title);
        break;
      case CollectionActionTypes.COL_CHANGE_TITLE_FINALIZE:
        this.save("title");
        break;
      case CollectionActionTypes.COL_CHANGE_TITLE_REVERT:
        this.revert("title");
        break;
      default:
        break;
    }
  }

  emitChange(changeEvent) {
    this.emit(changeEvent);
  }

  addChangeListener(changeEvent, callback) {
    this.on(changeEvent, callback);
  }

  removeChangeListener(changeEvent, callback) {
    this.removeListener(changeEvent, callback);
  }

  // Changes a property to a given value and adds it to
  // the open change list
  setProps(collection) {
    this.preview = collection.preview;
    this.published = collection.published;
    this.title = collection.title;
    this.emitChange("CollectionStoreChanged");
  }

  // Changes a property to a given value and adds it to
  // the open change list
  change(property, value) {
    // What to do if this property is already on the open change list?
    // We currently are not likely to have this problem, but this will
    // need to be expanded to handle that if we ever do
    this.openChanges[property] = { "previous": this[property], "new": value };
    this[property] = value;
    this.emitChange("CollectionStoreChanged");
  }

  // Saves the changes made to a property by removing it
  // from the open change list
  save(property) {
    delete this.openChanges[property];
  }

  // Reverts the last change for the given property
  revert(property) {
    if(this.openChanges[property]) {
      this[property] = this.openChanges[property].previous;
      delete this.openChanges[property];
      this.emitChange("CollectionStoreChanged");
    }
  }
}

var collectionStore = new CollectionStore();
module.exports = collectionStore;
