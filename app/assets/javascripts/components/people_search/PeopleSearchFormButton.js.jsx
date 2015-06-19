var React = require('react');
var PeopleSearchFormButton = React.createClass({
    buttonToggle: function() {
        return ( (!this.props.activePersonId) ? 'disabled' : false )
    },
    handleClick:  function() {
        this.props.selectPerson()
    },
    buttonStyle: function() {
        return { marginLeft: '10px' }
    },
    render: function() {
        return (
            <button disabled={this.buttonToggle()} onClick={this.handleClick} style={this.buttonStyle()} type="button" className="btn btn-primary">Add</button>
        );
    }
});
module.exports = PeopleSearchFormButton;
