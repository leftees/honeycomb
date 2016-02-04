var keyMirror = require('keymirror');

module.exports = keyMirror({
  MDC_LOAD: null, // Queries the backend and sets the state of the store based on the response
  MDC_CHANGE_FIELD: null, // Change a field's properties within the metadata configuration
});
