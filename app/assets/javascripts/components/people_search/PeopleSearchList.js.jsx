var PeopleSearchList = React.createClass({
    listToggle: function() {
        return { display: (this.props.hide ? 'none' : 'block') };
    },
    render: function() {
        var people = [];
        var person, person_key;
        if (this.props.people) {
            for (i = 0; i < this.props.people.length; i++) {
                person = this.props.people[i];
                person_key = person + i;
                people.push(<PeopleSearchListItem key={person_key} person={person} setActivePerson={this.props.setActivePerson} />);
            }
        }
        return (
            <div style={this.listToggle()} className="list-group" id="people_select_list" >
                {people}
            </div>
        );
    }
});
