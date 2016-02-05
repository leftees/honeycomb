var React = require('react');
var mui = require("material-ui");
var Dialog = mui.Dialog;
var RaisedButton = mui.RaisedButton;
var FlatButton = mui.FlatButton;
var update = require('react-addons-update');
var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var MetaDataConfigurationActions = require("../../actions/MetaDataConfigurationActions");
var MetaDataConfigurationActionTypes = require("../../constants/MetaDataConfigurationActionTypes");

var MetaDataFieldDialog = React.createClass({
  mixins: [MuiThemeMixin],

  propTypes: {
    open: React.PropTypes.bool.isRequired,
    updateUrl: React.PropTypes.string.isRequired,
    fieldName: React.PropTypes.string,
  },

  // Creating custom react link so that we can store the field values
  // in state.fieldValues instead of flat within state, in order
  // to easily serialize this to json when updating the store.
  linkFieldState: function(key) {
    return new ReactLink(
      this.state["fieldValues"][key],
      function(value) { this.updateFieldValue(key, value); }.bind(this)
    );
  },

  // Updates a specific value within state.fieldValues
  updateFieldValue: function(key, value) {
    var kvp = {};
    kvp[key] = value;
    var fieldValues = update(this.state.fieldValues, {$merge: kvp});
    this.setState({ fieldValues: fieldValues });
  },

  getInitialState: function() {
    return {
      open: this.props.open,
      fieldName: this.props.fieldName,
      saving: false,
    };
  },

  componentWillMount: function() {
    MetaDataConfigurationActions.on("ChangeFieldFinished", this.handleSaved);
  },

  componentWillReceiveProps: function(nextProps) {
    if(nextProps.open) {
      // Clone store field values, otherwise the linked states will directly change the store
      fieldValues = update(MetaDataConfigurationStore.fields[nextProps.fieldName], {});
      this.setState({
        open: nextProps.open,
        fieldName: nextProps.fieldName,
        fieldValues: fieldValues,
      });
    }
  },

  componentDidUpdate: function(prevProps, prevState) {
    if(this.state.open){
      this.refs.EditMetaDialog.show();
    } else {
      this.refs.EditMetaDialog.dismiss();
    }
  },

  handleSave: function() {
    MetaDataConfigurationActions.changeField(this.state.fieldName, this.state.fieldValues, this.props.updateUrl);
    this.setState({ saving: true});
  },

  handleSaved: function(success, data) {
    if(success) {
      this.setState({ open: false });
    } else {
      console.log("Add error handling stuff here when !success", data);
    }
    this.setState({ saving: false });
  },

  handleClose: function() {
    this.setState({ open: false });
  },

  getTypeOptions: function() {
    return [
      { payload: 'string', text: 'Text' },
      { payload: 'html', text: 'HTML' },
      { payload: 'date', text: 'Date' }
    ];
  },

  getFieldProps: function() {
    return [
      <mui.TextField style={{ width: "100%" }} floatingLabelText="Name" valueLink={ this.linkFieldState('name') } />,
      <mui.TextField style={{ width: "100%" }} floatingLabelText="Label" valueLink={ this.linkFieldState('label') } />,
      <mui.SelectField style={{ width: "100%" }} floatingLabelText="Type" menuItems={ this.getTypeOptions() } valueLink={ this.linkFieldState('type') } />,
      <mui.Checkbox style={{ width: "100%" }} label="Allow multiple values?" checkedLink={ this.linkFieldState('multiple') } />,
      <mui.Checkbox style={{ width: "100%" }} label="Always show on the item form?" checkedLink={ this.linkFieldState('defaultFormField') } />,
      <mui.Checkbox style={{ width: "100%" }} label="Require presence on all items?" checkedLink={ this.linkFieldState('required') } />,
    ];
  },

  render: function() {
    const actions = [
      <FlatButton
        label="Save"
        primary={true}
        disabled={this.state.saving}
        keyboardFocused={true}
        onTouchTap={this.handleSave}
      />,
      <FlatButton
        label="Close"
        primary={false}
        disabled={this.state.saving}
        keyboardFocused={false}
        onTouchTap={this.handleClose}
      />,
    ];
    return (
      <div>
        <Dialog
          ref="EditMetaDialog"
          title="Edit Metadata Field"
          actions={actions}
          modal={true}
          bodyStyle={{ margin: "0 auto 0 auto" }}
          contentStyle={{ width: "35%" }}
          style={{ zIndex: 100 }}
          openImmediately={this.props.open}
        >
          { this.state.open && this.getFieldProps() }
        </Dialog>
      </div>
    );
  }
});
module.exports = MetaDataFieldDialog;
