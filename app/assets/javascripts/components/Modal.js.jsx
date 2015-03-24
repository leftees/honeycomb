//app/assets/javascripts/components/modal/Modal.jsx

var Modal = React.createClass({
  displayName: 'Modal',

  propTypes: {
    id: React.PropTypes.string.isRequired,
    children: React.PropTypes.object.isRequired,
    title: React.PropTypes.string,
  },

  render: function () {
    return (
      <div className="modal fade" id={this.props.id} tabIndex="-1">
        <div className="modal-dialog modal-lg">
          <div className="modal-content">
            <div className="modal-header">
              <h4 class="modal-title">{this.props.title}</h4>
              <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <div className="modal-body">
              {this.props.children}
            </div>
          </div>
        </div>
      </div>
    );
  }
});

