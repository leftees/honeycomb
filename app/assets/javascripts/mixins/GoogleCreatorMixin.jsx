// Requires the following within the page that uses this mixin:
//  <script type="text/javascript" src="https://apis.google.com/js/api.js"></script>
//

var GoogleCreatorMixin = {
  propTypes: {
    developerKey: React.PropTypes.string.isRequired,
    clientId: React.PropTypes.string.isRequired,
    appId: React.PropTypes.string.isRequired,
    authUri: React.PropTypes.string.isRequired,
  },

  oauthToken: null,

  clientApiLoaded: false,

  loadCreator: function() {
    if(this.clientApiLoaded && this.oauthToken){
      this.createFile(this.fileCreated);
    } else {
      gapi.load("auth", {"callback": this.onAuthApiLoad});
      gapi.load("client", {"callback": this.onClientApiLoad});
    }
  },

  onClientApiLoad: function() {
    this.clientApiLoaded = true;
    this.createFile(this.fileCreated);
  },

  onAuthApiLoad: function() {
    gapi.auth.init(this.onAuthApiInit);
  },

  onAuthApiInit: function(clientId) {
    window.gapi.auth.authorize(
      {
        "client_id": this.props.clientId,
        "scope": "https://www.googleapis.com/auth/drive.file",
        "hd": "nd.edu"
      },
      this.handleAuthResult);
  },

  handleAuthResult: function(authResult) {
    if (authResult && !authResult.error) {
      this.oauthToken = authResult.access_token;
      this.createFile(this.fileCreated);
    }
  },

  createFile: function(callback) {
    if(this.clientApiLoaded && this.oauthToken){
      const boundary = 'foo_bar_baz';
      const delimiter = "\r\n--" + boundary + "\r\n";
      const close_delim = "\r\n--" + boundary + "--";

      var fileData = this.getFileData();

      var metadata = {
        'title': fileData.fileName,
        'mimeType': fileData.mimeType
      };

      var request = gapi.client.request({
          'path': 'drive/v2/files',
          'method': 'POST',
          'params': {},
          'headers': {},
          'body': metadata});
      request.execute(callback);
    }
  },
};

module.exports = GoogleCreatorMixin;
