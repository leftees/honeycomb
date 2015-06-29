function Mediator() {
  // hashmap of message type to list of subscribers for that message type
  this.subscribers = [];
}

Mediator.prototype.subscribe = function(type, subscriberCallback) {
  if (!(type in this.subscribers)) {
    this.subscribers[type] = [];
  }
  this.subscribers[type].push(subscriberCallback);
};

Mediator.prototype.send = function(type, message, excludes) {
  if(type in this.subscribers) {
    this.subscribers[type].forEach(function(callback) {
      var exclude = excludes && (excludes.indexOf(callback) != -1);
      if(!exclude) {
         callback(type, message);
      }
    }.bind(this));
  }
};

var mediator = mediator || new Mediator();
module.exports = mediator;
