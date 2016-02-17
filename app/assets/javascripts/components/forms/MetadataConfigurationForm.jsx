var React = require("react");
var mui = require("material-ui");

var ReactLink = require('react/lib/ReactLink');
var ReactStateSetters = require('react/lib/ReactStateSetters');
var MetaDataConfigurationActions = require("../../actions/MetaDataConfigurationActions");
var Paper = mui.Paper;
var List = mui.List;
var FontIcon = mui.FontIcon;
var IconButton = mui.IconButton;
var Toggle = mui.Toggle;
var Colors = require("material-ui/lib/styles/colors");
var MoreVertIcons = require("material-ui/lib/svg-icons/navigation/more-vert");

var MetaDataConfigurationForm = React.createClass({
  propTypes: {
    baseUpdateUrl: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      fields: this.filteredFields(false),
      selectedField: undefined,
      showInactive: false,
    };
  },

  componentDidMount: function() {
    MetaDataConfigurationStore.on("MetaDataConfigurationStoreChanged", this.setFormFieldsFromConfiguration);
    MetaDataConfigurationStore.getAll();
  },

  filteredFields: function(showInactive) {
    var fields = _.filter(MetaDataConfigurationStore.fields, function(field) {  return showInactive || field.active; }.bind(this));
    return this.sortedFields(fields);
  },

  sortedFields: function(fields) {
    return _.sortBy(fields, 'order');
  },

  setFormFieldsFromConfiguration: function() {
    this.setState({
      fields: this.filteredFields(this.state.showInactive),
      selectedField: undefined,
    });
  },

  friendlyType: function(type) {
    switch(type){
      case 'string':
        return "Text";
      case 'html':
        return "HTML";
      case 'date':
        return "Date";
      default:
        return type;
    }
  },

  getLeftIcon: function(type) {
    switch(type){
      case 'string':
        return (<FontIcon className="material-icons">short_text</FontIcon>);
      case 'html':
        return (<FontIcon className="material-icons">format_size</FontIcon>);
      case 'date':
        return (<FontIcon className="material-icons">date_range</FontIcon>);
      default:
        return null;
    }
  },

  getRightIcon: function(field) {
    if(_.contains(field.immutable, "active")) {
      return null;
    }

    if(field.active) {
      return (
        <IconButton
          tooltip="Remove"
          tooltipPosition="top-center"
          onTouchTap={function() { this.handleRemove(field.name) }.bind(this) }
        >
          field.active && <FontIcon className="material-icons" color={Colors.grey500} hoverColor={Colors.red500}>remove</FontIcon>
        </IconButton>
      );
    } else {
      return (
        <IconButton
          tooltip="Restore"
          tooltipPosition="top-center"
          onTouchTap={function() { this.handleRestore(field.name) }.bind(this) }
        >
          field.active && <FontIcon className="material-icons" color={Colors.grey500} hoverColor={Colors.green500}>undo</FontIcon>
        </IconButton>
      );
    }
  },

  getFieldItems: function() {
    return this.state.fields.map(function(field) {
      return (
        <mui.ListItem
          key={ field.name }
          primaryText={ field.label }
          secondaryText={ field.required && "Required" }
          leftIcon={this.getLeftIcon(field.type)}
          rightIconButton={this.getRightIcon(field)}
          onTouchTap={function() { this.handleEditClick(field.name) }.bind(this) }
        />
      );
    }.bind(this));
  },

  handleRemove: function(fieldName) {
    MetaDataConfigurationActions.changeActive(fieldName, false, this.props.baseUpdateUrl)
  },

  handleRestore: function(fieldName) {
    MetaDataConfigurationActions.changeActive(fieldName, true, this.props.baseUpdateUrl)
  },

  handleEditClick: function(fieldName) {
    this.setState({ selectedField: fieldName });
  },

  handleShowInactive: function(e, value) {
    this.setState({
      showInactive: value,
      fields: this.filteredFields(value),
      selectedField: undefined,
    });
  },

  render: function(){
    const { selectedField } = this.state;
    return (
      <Paper style={{ maxWidth: "300px" }} zDepth={0}>
        <Toggle label="Show Inactive Fields" onToggle={ this.handleShowInactive } />
        <MetaDataFieldDialog fieldName={ selectedField } open={ selectedField != undefined } baseUpdateUrl={ this.props.baseUpdateUrl }/>
        <List >
          {this.getFieldItems()}
        </List>
      </Paper>
    );
  }
});

module.exports = MetaDataConfigurationForm;
