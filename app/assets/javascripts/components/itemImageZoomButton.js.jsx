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
        <button className="btn btn-default hc-image-zoom-button" data-target={zoomID} onClick={this.handleClick}><span className="glyphicon glyphicon-zoom-in"></span></button>
        <div className="hc-image-zoom-button-inner">
          <OpenseadragonViewer image={this.props.image} containerID={zoomID} fullPage={fullPage} />
        </div>
      </div>
    );
  }
});
