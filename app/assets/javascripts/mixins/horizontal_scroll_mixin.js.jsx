/** @jsx React.DOM */

var HorizontalScrollMixin = {
  setElement: function(element) {
    this.element = document.getElementById(element);
  },

  setHorizontalScrollOnElement: function(element, speed) {
    this.setElement(element);

    if (this.checkScrollRight()) {
      this.setState( { scroll: true });
      setTimeout(this.scroll, 50, speed);
    }
    else if (this.checkScrollLeft()) {
      this.setState( { scroll: true });
      setTimeout(this.scroll, 50, -speed);
    }
    else if (this.checkDeadZone()) {
        this.setState( { scroll: false } );
    }
  },

  scroll: function(speed) {
    if (this.state.scroll) {
      this.element.scrollLeft  += speed;
      setTimeout(this.scroll, 100, speed);
    }
  },

  box_left: function() {
    return this.element.getBoundingClientRect().left + 100;
  },

  box_right: function() {
    return this.element.getBoundingClientRect().right - 100;
  },

  checkDeadZone: function () {
    return event.pageX <= this.box_right() && event.pageX >= this.box_left() && this.state.scroll;
  },

  checkScrollLeft: function () {
    return event.pageX < this.box_left() && !this.state.scroll;
  },

  checkScrollRight: function () {
    return event.pageX > this.box_right() && !this.state.scroll;
  }

};
