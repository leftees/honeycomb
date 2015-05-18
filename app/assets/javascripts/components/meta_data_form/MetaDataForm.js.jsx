//app/assets/javascripts/components/modal/Modal.jsx

var MetaDataForm = React.createClass({
  displayName: 'Form',

  propTypes: {
    authenticityToken: React.PropTypes.string.isRequired,
    method: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired,
    fields: React.PropTypes.object,
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

          <StringField name="item[title]" id="item_title" required="true" title="Title" value={this.state.formValues['item_title']} handleFieldChange={this.handleFieldChange} />
          <TextField  name="item[description]" id="item_description" required="" title="Description" value={this.state.formValues['item_description']} handleFieldChange={this.handleFieldChange} />
          <TextField  name="item[transcription]" id="item_transcription" required="" title="Transcription" value={this.state.formValues['item_transcription']} handleFieldChange={this.handleFieldChange} />
          <StringField  name="item[manuscript_url]" id="item_manuscript_url" required="" title="Digitized Manuscript URL" value={this.state.formValues['item_manuscript_url']} handleFieldChange={this.handleFieldChange} placeholder="http://" help="Link to externally hosted manuscript viewer." />

          <input type="submit" value="save" className="btn btn-primary" />
        </Form>
      </Panel>
    );
  }
});

