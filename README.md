# Node-RedSismica 
[![Build Status](https://drone.io/github.com/jonahoffline/node-redsismica/status.png)](https://drone.io/github.com/jonahoffline/node-redsismica/latest) [![Build Status](https://travis-ci.org/jonahoffline/node-redsismica.png)](https://travis-ci.org/jonahoffline/node-redsismica) [![Dependency Status](https://gemnasium.com/jonahoffline/node-redsismica.png)](https://gemnasium.com/jonahoffline/node-redsismica) [![NPM version](https://badge.fury.io/js/redsismica.png)](http://badge.fury.io/js/redsismica)

Gets last felt earthquakes in Puerto Rico.

[![NPM](https://nodei.co/npm/redsismica.png?downloads=true)](https://nodei.co/npm/redsismica/)

**Demo:** [RedSismica API Server (DigitalOcean VPS)](http://pixelhipster.com:9090)

## Installation

Run the following command to install.

    $ npm install redsismica
    
## Usage

To manually scrape all recent felt earthquakes:

```coffee-script
RedSismica = require 'redsismica'

redSismica = new RedSismica
redSismica.fetchEvents (data) ->
  console.log data
```	

To manually scrape all recent felts and bulletin data:

```coffee-script
RedSismica = require 'redsismica'

redSismica = new RedSismica
redSismica.fetchEvents (data) ->
  console.log data
  r.fetchBulletins (bulletinData) ->
    console.log bulletinData
```	

To run the simple API server in src/api_server.coffee:

```console
coffee src/server_api.coffee
```

## Author
  * [Jonah Ruiz](http://www.pixelhipsters.com)

## Contributing

Is it worth it? let me fork it

I put my thing down, flip it and debug it

Ti gubed dna ti pilf nwod gniht ym tup I

Ti gubed dna ti pilf nwod gniht ym tup I

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/jonahoffline/node-redsismica/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
