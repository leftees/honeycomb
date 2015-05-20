//app/assets/javascripts/components/modal/Modal.jsx

var ItemMetaDataForm = React.createClass({
  displayName: 'ItemMetaDataForm',

  propTypes: {
    authenticityToken: React.PropTypes.string.isRequired,
    method: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired,
    errors: React.PropTypes.object,
    url: React.PropTypes.string.isRequired,
  },

  getDefaultProps: function() {
    return {
      method: "post",
    };
  },

  getInitialState: function() {
    return {
      formValues: this.props.data
    }
  },

  handleSave: function() {

  },

  handleFieldChange: function(field, value) {
    this.state.formValues[field] = value;
    this.setState({
      formValues: this.state.formValues
    })
  },

  render: function () {
    return (
      <Panel PanelTitle="Meta Data">
        <Form id="meta_data_form" url={this.props.url} authenticityToken={this.props.authenticityToken} method={this.props.method}>

          <StringField objectType="item" name="title" required="true" title="Title" value={this.state.formValues['title']} handleFieldChange={this.handleFieldChange} />
          <TextField  objectType="item" name="description" required="" title="Description" value={this.state.formValues['description']} handleFieldChange={this.handleFieldChange} />
          <TextField objectType="item" name="transcription" required="" title="Transcription" value={this.state.formValues['transcription']} handleFieldChange={this.handleFieldChange} />
          <StringField  objectType="item" name="manuscript_url" required="" title="Digitized Manuscript URL" value={this.state.formValues['manuscript_url']} handleFieldChange={this.handleFieldChange} placeholder="http://" help="Link to externally hosted manuscript viewer." />

          <input type="submit" value="save" onClick={this.handleSave} className="btn btn-primary" />
        </Form>
      </Panel>
    );
  }
});

