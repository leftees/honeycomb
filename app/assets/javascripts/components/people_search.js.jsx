/** @jsx React.DOM */

var PeopleSearch = React.createClass({
    getInitialState: function() {
        return { peopleList: [],
            activePersonId: null,
            currentSearch: null,
            lastSearch: null,
        }
    },
    updateSearchValue: function(searchValue) {
        this.setState({
            currentSearch: searchValue,
            activePersonId: null,
        });
    },
    loadPeopleFromServer: function() {
        var searchValue = this.state.currentSearch;
        if (searchValue && !this.state.activePersonId && searchValue != this.state.lastSearch) {
            var searchUrl = this.props.searchUrl + '?term=' + encodeURIComponent(searchValue);
            $.ajax({
                url: searchUrl,
                dataType: "json",
                success: (function(data) {
                    this.setState({
                        peopleList: data,
                        lastSearch: searchValue
                    });
                }).bind(this),
                error: (function(xhr, status, err) {
                    console.error(searchUrl, status, err.toString());
                }).bind(this)
            });
        }
    },
    setActivePerson: function(person) {
        var id = null;
        var search = null;
        if (person) {
            id = person.id;
            search = person.label;
        }
        this.setState({
            activePersonId: id,
            currentSearch: search,
            peopleList: []
        });
    },
    selectActivePerson: function() {
        if (this.props.selectPerson) {
            this.props.selectPerson(this.state.activePersonId);
        }
        this.setActivePerson(null);
    },
    componentWillMount: function() {
        this.debouncedLoadPeople = _.debounce(function(event) {
            this.loadPeopleFromServer();
        }.bind(this), 100);
    },
    componentDidUpdate: function(prevProps, prevState) {
        if (this.state.currentSearch && this.state.currentSearch != prevState.currentSearch) {
            this.debouncedLoadPeople();
        }
    },
    render: function() {
        return (
            <div>
                <div className="people_list" >
                    <SearchBox
                        invokeSearch={this.updateSearchValue}
                        selectPerson={this.selectActivePerson}
                        currentValue={this.state.currentSearch}
                        setActivePerson={this.setActivePerson}
                        activePersonId={this.state.activePersonId} />
                    <PeopleList
                        people={this.state.peopleList}
                        setActivePerson={this.setActivePerson}
                        activePersonId={this.state.activePersonId} />
                </div>
            </div>
        );
    }
});

var SearchBox = React.createClass({
    handleChange:  function(event) {
        this.props.invokeSearch(event.target.value);
        this.refs.theInput
    },
    render: function() {
        return (
            <div>
                <input ref="theInput" type="text" value={this.props.currentValue} onChange={this.handleChange} />
                <SearchButton
                    activePersonId={this.props.activePersonId}
                    selectPerson={this.props.selectPerson} />
            </div>
        );
    }

});

var SearchButton = React.createClass({
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


var PeopleList = React.createClass({
    listToggle: function() {
        return { display: (this.props.activePersonId ? 'none' : 'block') }
    },
    render: function() {
        var people = [];
        var person, person_key;
        if (this.props.people) {
            for (i = 0; i < this.props.people.length; i++) {
                person = this.props.people[i];
                person_key = person + i;
                people.push(<Person key={person_key} person={person} setActivePerson={this.props.setActivePerson} />);
            }
        }
        return (
            <div style={this.listToggle()} className="list-group" id="people_select_list" >
                {people}
            </div>
        );
    }
});

var Person = React.createClass({
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
