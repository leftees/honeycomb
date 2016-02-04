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
    // TODO: This is bad. Use update here.
    var fieldValues = this.state.fieldValues;
    fieldValues[key] = value;
    this.setState({ fieldValues: fieldValues });
  },

  getInitialState: function() {
    return {
      open: this.props.open,
      fieldName: this.props.fieldName,
    };
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
    this.setState({ open: false });
    MetaDataConfigurationActions.changeField(this.state.fieldName, this.state.fieldValues, this.props.updateUrl);
  },

  handleCancel: function() {
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
      <mui.TextField floatingLabelText="Name" valueLink={ this.linkFieldState('name') } />,
      <mui.TextField floatingLabelText="Label" valueLink={ this.linkFieldState('label') } />,
      <mui.TextField floatingLabelText="Boost" valueLink={ this.linkFieldState('boost') } />,
      <mui.TextField floatingLabelText="Help" valueLink={ this.linkFieldState('help') } />,
      <mui.TextField floatingLabelText="Order" valueLink={ this.linkFieldState('order') } />,
      <mui.TextField floatingLabelText="Placeholder" valueLink={ this.linkFieldState('placeholder') } />,
      <mui.SelectField floatingLabelText="Type" menuItems={ this.getTypeOptions() } valueLink={ this.linkFieldState('type') } />,
      <mui.Checkbox label="Allow multiple values?" checkedLink={ this.linkFieldState('multiple') } />,
      <mui.Checkbox label="Always show on the item edit form?" checkedLink={ this.linkFieldState('defaultFormField') } />,
      <mui.Checkbox label="Require presence on all items?" checkedLink={ this.linkFieldState('required') } />,
    ];
  },

  render: function() {
    const actions = [
      <FlatButton
        label="Save"
        primary={true}
        keyboardFocused={true}
        onTouchTap={this.handleSave}
      />,
      <FlatButton
        label="Cancel"
        primary={false}
        keyboardFocused={false}
        onTouchTap={this.handleCancel}
      />,
    ];
    return (
      <div>
        <Dialog
          ref="EditMetaDialog"
          title="Edit Metadata Field"
          actions={actions}
          modal={true}
          style={{zIndex: 100}}
          openImmediately={this.props.open}
        >
          { this.state.open && this.getFieldProps() }
        </Dialog>
      </div>
    );
  }
});
module.exports = MetaDataFieldDialog;
