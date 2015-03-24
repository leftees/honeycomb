var ItemImageZoomButton = React.createClass({
  propTypes: {
    image: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.object,
    ]),
    itemID: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      image: null,
      zoomClicked: null,
    };
  },

  handleClick: function() {
    this.setState({
      zoomClicked: Date.now()
    });
  },

  render: function() {
    var zoomID = '#hcItemZoom' + this.props.itemID;
    var fullPage = !!this.state.zoomClicked;
    return (
      <div className="hc-image-zoom-button-outer">
          <a style={{backgroundColor: 'white'}} href="#" data-toggle="modal" data-target="#hc-image-zoom-modal" className="btn btn-default btn-raised hc-image-zoom-button"><span className="glyphicon glyphicon-zoom-in"></span></a>
          <Modal id="hc-image-zoom-modal" title="Scroll in and out to zoom">
            <OpenseadragonViewer image={this.props.image} containerID={zoomID} height="600" />
          </Modal>

      </div>
    );
  }
});
