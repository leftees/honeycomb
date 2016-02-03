var React = require('react');
var mui = require("material-ui");
var Dialog = mui.Dialog;
var RaisedButton = mui.RaisedButton;
var FlatButton = mui.FlatButton;

var MetaDataFieldDialog = React.createClass({
  mixins: [MuiThemeMixin, LinkedStateMixin],

  propTypes: {
    open: React.PropTypes.bool.isRequired,
    fieldName: React.PropTypes.string,
  },

  getInitialState: function() {
    return {
      open: this.props.open,
    };
  },

  componentWillReceiveProps: function(nextProps) {
    if(nextProps.open) {
      var fieldValues = MetaDataConfigurationStore.fields[nextProps.fieldName];
      this.setState({
        open: nextProps.open,
        boost: fieldValues.boost,
        help: fieldValues.help,
        order: fieldValues.order,
        placeholder: fieldValues.placeholder,
        name: fieldValues.name,
        defaultFormField: fieldValues.defaultFormField,
        required: fieldValues.required,
        type: fieldValues.type,
        label: fieldValues.label,
        multiple: fieldValues.multiple
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
    // Change store
    this.setState({ open: false });
    console.log(this.state);
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
      <mui.TextField floatingLabelText="Name" valueLink={ this.linkState('name') } />,
      <mui.TextField floatingLabelText="Label" valueLink={ this.linkState('label') } />,
      <mui.TextField floatingLabelText="Boost" valueLink={ this.linkState('boost') } />,
      <mui.TextField floatingLabelText="Help" valueLink={ this.linkState('help') } />,
      <mui.TextField floatingLabelText="Order" valueLink={ this.linkState('order') } />,
      <mui.TextField floatingLabelText="Placeholder" valueLink={ this.linkState('placeholder') } />,
      <mui.SelectField floatingLabelText="Type" menuItems={ this.getTypeOptions() } valueLink={ this.linkState('type') } />,
      <mui.Checkbox label="Allow multiple values?" checkedLink={ this.linkState('multiple') } />,
      <mui.Checkbox label="Always show on the item edit form?" checkedLink={ this.linkState('defaultFormField') } />,
      <mui.Checkbox label="Require presence on all items?" checkedLink={ this.linkState('required') } />,
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
