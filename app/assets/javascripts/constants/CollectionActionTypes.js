var keyMirror = require('keymirror');

module.exports = keyMirror({
  COL_SET_STATE: null, // Sets the initial values without making a change to the backend.
                       // Should only be used to setup the initial state of the store.
  COL_CHANGE_PUBLISHED: null, // A change has been requested to the published field
  COL_CHANGE_PUBLISHED_FINALIZE: null, // A change to published was successful and should be finalized
  COL_CHANGE_PUBLISHED_REVERT: null, // A change to published failed and should be reverted
  COL_CHANGE_PREVIEW: null,
  COL_CHANGE_PREVIEW_FINALIZE: null,
  COL_CHANGE_PREVIEW_REVERT: null
});
