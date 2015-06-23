var React = require('react');
var PeopleSearchForm = React.createClass({
    handleChange:  function(event) {
        this.props.invokeSearch(event.target.value);
        this.refs.theInput
    },
    render: function() {
        return (
            <div>
                <input ref="theInput" type="text" value={this.props.currentValue} onChange={this.handleChange} />
                <PeopleSearchFormButton
                    activePersonId={this.props.activePersonId}
                    selectPerson={this.props.selectPerson} />
            </div>
        );
    }

});
module.exports = PeopleSearchForm;
