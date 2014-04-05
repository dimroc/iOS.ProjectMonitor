Frontend: Parse Cloud Code
==========================

Node.js Cloud Code hosted on parse.com.

Main Features:

1. Hosts endpoint to authenticate mobile requests to join private [pusher](http://www.pusher.com) channels. This pusher channel is used to push build changes in real-time to the mobile client.

Initial Setup
-----

1. Copy `config/global.json.example` to `config/global.json`
2. Add your parse application with the following command: `$ parse add applicationname`
3. Add your Pusher credentials to `cloud/credentials.js`
4. In Parse settings -> Web Hosting, add the correct ParseApp subdomain.
