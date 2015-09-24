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

  addFieldsSelectOptions: function () {
    var map_function = function (field) {
      if (!this.fieldInForm(field)) {
        var h = {};
        h.payload = field.name;
        h.text = field.label;

        return (h);
      }
    };
    map_function = _.bind(map_function, this);
    return [{ payload: '', text: 'Add a New Field'}].concat(_.reject(_.map(this.props.selectableFields, map_function), function(val){ return _.isUndefined(val)}));
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
      return (<p>Not loading</p>);
    }
  }
});

module.exports = ItemMetaDataSelectAdditionalFields;
