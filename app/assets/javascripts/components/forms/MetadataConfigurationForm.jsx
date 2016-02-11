var React = require('react');
var mui = require("material-ui");

var MetaDataConfigurationForm = React.createClass({
  propTypes: {
    updateUrl: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      fields: this.sortedFields(),
      selectedField: undefined,
    };
  },

  componentWillMount: function() {
    MetaDataConfigurationStore.on("MetaDataConfigurationStoreChanged", this.setFormFieldsFromConfiguration);
    MetaDataConfigurationStore.getAll();
  },

  sortedFields: function() {
    return _.sortBy(MetaDataConfigurationStore.fields, 'order');
  },

  setFormFieldsFromConfiguration: function() {
    this.setState({
      fields: this.sortedFields(),
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

  getFieldRows: function() {
    return this.state.fields.map(function(field) {
      return (
        <mui.TableRow>
          <mui.TableRowColumn><mui.FlatButton
            label="Edit"
            onTouchTap={ function() { this.handleRowClick(field.name); }.bind(this) }
          /></mui.TableRowColumn>
          <mui.TableRowColumn>{ field.label }</mui.TableRowColumn>
          <mui.TableRowColumn>{ this.friendlyType(field.type) }</mui.TableRowColumn>
          <mui.TableRowColumn><mui.Checkbox disabled={ true } defaultChecked={ field.multiple } /></mui.TableRowColumn>
          <mui.TableRowColumn><mui.Checkbox disabled={ true } defaultChecked={ field.required } /></mui.TableRowColumn>
        </mui.TableRow>
      );
    }.bind(this));
  },

  handleRowClick: function(field) {
    this.setState({ selectedField: field });
  },

  handleNewClick: function() {
    this.setState({ selectedField: "NEWFIELD"});
  },

  render: function(){
    const { selectedField } = this.state;
    return (
      <div>
        <mui.RaisedButton label="New Metadata Field" onClick={ this.handleNewClick } />
        <MetaDataFieldDialog fieldName={ selectedField } open={ selectedField != undefined } updateUrl={ this.props.updateUrl }/>
        <mui.Table>
          <mui.TableHeader displaySelectAll={ false } >
            <mui.TableRow>
              <mui.TableHeaderColumn/>
              <mui.TableHeaderColumn>Label</mui.TableHeaderColumn>
              <mui.TableHeaderColumn>Type</mui.TableHeaderColumn>
              <mui.TableHeaderColumn>Allows Multiples</mui.TableHeaderColumn>
              <mui.TableHeaderColumn>Required</mui.TableHeaderColumn>
            </mui.TableRow>
          </mui.TableHeader>
          <mui.TableBody displayRowCheckbox={ false } >
            { this.getFieldRows() }
          </mui.TableBody>
        </mui.Table>
      </div>
    );
  }
});

module.exports = MetaDataConfigurationForm;
