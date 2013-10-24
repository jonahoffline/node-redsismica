# Node-RedSismica [![Build Status](https://travis-ci.org/jonahoffline/node-redsismica.png)](https://travis-ci.org/jonahoffline/node-redsismica) [![Dependency Status](https://gemnasium.com/jonahoffline/node-redsismica.png)](https://gemnasium.com/jonahoffline/node-redsismica)

Gets last felt earthquakes in Puerto Rico.


## Installation

Run the following command to install.

    $ npm install redsismica
    
## Usage

To manually scrape all recent felt earthquakes:

```coffee-script
require 'redsismica'

redSismica = new RedSismica
redSismica.fetchEvents (data) ->
  console.log data
```	

To manually scrape all recent felts and bulletin data:

```coffee-script
require 'redsismica'

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
