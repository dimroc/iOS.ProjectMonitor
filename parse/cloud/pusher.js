// Taken from https://github.com/pusher/pusher-node-server
// because Parse Cloud code does not support npm packages
module.exports = (function() {
  var crypto = require('crypto');

  var Pusher = function(options) {
    this.options = options;

    // support appKey being provided instead of key for legacy support
    if( this.options.appKey ) {
      this.options.key = this.options.appKey;
      delete this.options.appKey;
    }

    return this;
  };

  Pusher.prototype = {
    domain: 'api.pusherapp.com',
    scheme: 'http',
    port: 80
  };

  Pusher.prototype.auth = function(socketId, channel, channelData) {
    var returnHash = {}
    var channelDataStr = ''
    if (channelData) {
      channelData = JSON.stringify(channelData);
      channelDataStr = ':' + channelData;
      returnHash['channel_data'] = channelData;
    }
    var stringToSign = socketId + ':' + channel + channelDataStr;
    returnHash['auth'] = this.options.key + ':' + crypto.createHmac('sha256', this.options.secret).update(stringToSign).digest('hex');
    return(returnHash);
  };

  return Pusher;
})();
