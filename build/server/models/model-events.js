// Generated by CoffeeScript 1.8.0
var EventEmitter, _;

EventEmitter = require('events').EventEmitter;

_ = require('lodash');

module.exports.wrapModel = function(Model) {
  var _oldCreate, _oldDestroy, _oldUpdateAttributes;
  Model.ee = new EventEmitter();
  Model.on = function() {
    return Model.ee.on.apply(Model.ee, arguments);
  };
  _oldCreate = Model.create;
  Model.create = function(data, callback) {
    return _oldCreate.call(Model, data, function(err, created) {
      if (!err) {
        Model.ee.emit('create', created);
      }
      return callback(err, created);
    });
  };
  _oldUpdateAttributes = Model.prototype.updateAttributes;
  Model.prototype.updateAttributes = function(data, callback) {
    var old;
    old = _.cloneDeep(this.toObject());
    return _oldUpdateAttributes.call(this, data, (function(_this) {
      return function(err, updated) {
        if (!err) {
          Model.ee.emit('update', _this, old);
        }
        return callback(err, updated);
      };
    })(this));
  };
  _oldDestroy = Model.prototype.destroy;
  Model.prototype.destroy = function(callback) {
    var id, old;
    old = this.toObject();
    id = old.id;
    return _oldDestroy.call(this, function(err) {
      if (!err) {
        Model.ee.emit('delete', id, old);
      }
      return callback(err);
    });
  };
  return Model;
};
