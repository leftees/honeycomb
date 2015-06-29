var APIResponseMixin = {
  // Some controllers will respond with a JSON containing
  // the status code and a more specific error message for why
  // that response was given. When that is present, returns that
  // error message. When it is not present, returns the status text
  // from the xml http request as a fallback.
  apiErrorToString: function(xhr) {
    errors = xhr.responseJSON || {};
    apiMessage = errors[xhr.status] || xhr.statusText;
    return apiMessage;
  },
};
module.exports = APIResponseMixin;