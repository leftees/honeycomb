var PeopleSearchListItem = React.createClass({
    handleClick:  function(event) {
        event.preventDefault();
        if (this.props.person.id) {
            this.props.setActivePerson(this.props.person);
        }
    },
    render: function() {
        return (
            <a href="#" onClick={this.handleClick} className="list-group-item person_selection">{this.props.person.label}</a>
        );
    }
});
