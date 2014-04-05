var express = require('express');
var Credentials = require('cloud/credentials.js');
var Pusher = require('cloud/pusher.js');

var pusher = new Pusher(Credentials.pusher);
var app = express();
app.use(express.bodyParser());    // Middleware for reading request body

// Authenticate a user for the private pusher channel
// if the sessionToken passed from the mobile client matches
// what's on the server.
var pusherAuth = express.basicAuth(function(userId, sessionToken, callback) {
  var query = new Parse.Query("User");

  query.get(userId, {
    success: function(object) {
      console.log("Successfully retrieved user " + object.getUsername());
      var rval = object.getSessionToken() == sessionToken ? object : false;
      rval = object; // Set to object for dev
      if (!rval) {
        console.log("Failed to match session token " + sessionToken + " with servers: " + object.getSessionToken());
      }
      callback(null, rval);
    },
    error: function(object, error) {
      console.log("Unable to retrieve user with id " + userId, object, error);
      callback(error, false);
    }
  });
});

app.post('/pusher/auth', pusherAuth, function(req, res) {
  var channel = req.body.channel_name;
  var socketId = req.body.socket_id;

  if (!channel) {
    res.status(400).send({result: "missing channel_name"});
    return;
  }

  var channelId = channel.substr(13); // channel: private-user_USERID
  var userId = req.user.id;

  console.log("channelId: " + channelId)
  console.log("userId: " + userId);

  if (channelId == userId) {
    var auth = pusher.auth( socketId, channel );
    res.send(auth);
  } else {
    res.status(401).send({result: "unauthorized"});
  }
});

app.listen();
