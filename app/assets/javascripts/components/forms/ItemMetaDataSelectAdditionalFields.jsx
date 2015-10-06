/*jshint esnext: true */

//app/assets/javascripts/components/forms/ItemMetaDataSelectAdditionalFields.jsx
var React = require('react');
var mui = require("material-ui");
var DropDownMenu = mui.DropDownMenu;

var ItemMetaDataSelectAdditionalFields = React.createClass({
  mixins: [MuiThemeMixin],
  propTypes: {
    displayedFields: React.PropTypes.any,
    selectableFields: React.PropTypes.any,
    onChangeHandler: React.PropTypes.func.isRequired,
  },

  getDefaultProps: function() {
    return {
      displayedFields: {},
      selectableFields: [],
    }
  },

  mapFieldToOption: function(field) {
    if (!this.fieldInForm(field)) {
      var h = {};
      h.payload = field.name;
      h.text = field.label;

      return (h);
    }
  },

  addFieldsSelectOptions: function () {
    var options = _.map(this.props.selectableFields, this.mapFieldToOption);
    options = _.reject(options, function(val){ return _.isUndefined(val)})
    options = [{ payload: '', text: 'Add a New Field'}].concat(options);

    return options
  },

  fieldInForm: function (field) {
    return this.props.displayedFields[field.name] || field.defaultFormField;
  },

  selectableFieldsLoaded: function() {
    return (!this.props.selectableFieldsLoaded);
  },

  render: function() {
    if (!this.selectableFieldsLoaded()) {
      return <p>loading...</p>
    }
    var dropDownIconStyle = {
      right: this.muiTheme.spacing.desktopGutterLess,
    };
    var underlineStyle = {
      borderTop: "solid 2px rgb(44, 88, 130)",
    };
    var options = this.addFieldsSelectOptions();

    var dropdown_menu = (
      <DropDownMenu
        menuItems={options}
        iconStyle={dropDownIconStyle}
        underlineStyle={underlineStyle}
        selectedIndex={this.props.menuIndex}
        onChange={this.props.onChangeHandler} />
    );

    if (options.length > 1) {
      return dropdown_menu;
    } else {
      return (<div></div>);
    }
  }
});

module.exports = ItemMetaDataSelectAdditionalFields;
