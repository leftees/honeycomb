//app/assets/javascripts/components/modal/Modal.jsx

var Modal = React.createClass({
  displayName: 'Modal',

  propTypes: {
    id: React.PropTypes.string.isRequired,
    children: React.PropTypes.oneOfType([
      React.PropTypes.object,
      React.PropTypes.array,
    ]).isRequired,
    title: React.PropTypes.string,
    closeText: React.PropTypes.string,
  },

  getDefaultProps: function() {
    return {
      closeText: "Close",
    };
  },

  componentDidMount: function() {
    if (this.props.closeCallback) {
      $('#' + this.props.id).on('hide.bs.modal', function (e) {
        this.props.closeCallback(e);
      }.bind(this));
    }
  },

  render: function () {
    return (
      <div className="modal fade" id={this.props.id} tabIndex="-1">
        <div className="modal-dialog modal-lg">
          <div className="modal-content">
            <div className="modal-header">
              <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
              <h4 className="modal-title">{this.props.title}</h4>
            </div>
            <div className="modal-body">
              {this.props.children}
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-default" data-dismiss="modal">{this.props.closeText}</button>
            </div>
          </div>
        </div>
      </div>
    );
  }
});

