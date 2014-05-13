    _ = require('lodash')
    require('../src/chainable.litcoffee')(_)

#Chainable Transformers in Angular.js

##### _.chainable aims to answer many of the downsides of a collection-less library like angular.js.

It takes an object containing methods and creates a new underscore instance with your methods attached. This means you can use any of your own methods, or any underscore methods in the chain.

First lets setup some data for a first person shooter game:

    players = [
       { firstName: 'Bobby', lastName: 'Bouche', kills: 125, deaths: 63, shots: 128  }
       { firstName: 'Annie', lastName: 'Smalls', kills: 201, deaths: 14, shots: 2432 }
       { firstName: 'Jacob', lastName: 'Jones',  kills: 101, deaths: 188, shots: 201 }
     ]

Here we create our transformer where we define the chainable method:

    transform = _.chainable
       kdr: (p) ->
         p.kills / p.deaths
       accuracy: (p) ->
         p.kills / p.shots
       score: (p) -> @kdr(p) + @accuracy(p)

_.chainable adds two extra methods:

Attr, which is a simple method for accessing object attributes.

    console.log transform(players).max('kills').attr('firstName').value()
    # Annie

Including takes either an object or an array, an attribute name, and an optional callback method

The object -- or each object in the array -- is then extended with the attribute name and the result of calling the callback method on (each) object.

    # including on an array, with callback function
    console.log transform(players).including('fullName', (o) -> "#{o.firstName} #{o.lastName }").value()
    # { firstName: 'Bobby', lastName: 'Bouche', fullName: "Bobby Bouche", kills: 125, deaths: 63, shots: 128  }
    # { firstName: 'Annie', lastName: 'Smalls', fullName: "Annie Smalls", kills: 201, deaths: 14, shots: 2432 }
    # { firstName: 'Jacob', lastName: 'Jones',  fullName: "Jacob Jones", kills: 101, deaths: 188, shots: 201 }

    # including on a single object (max returns the player with the max for a certain attribute, this is a standard underscore method)
    console.log transform(players).max('kills').including('fullName', (o) -> "#{o.firstName} #{o.lastName}").value()
    # { firstName: 'Annie', lastName: 'Smalls', fullName: "Annie Smalls", kills: 201, deaths: 14, shots: 2432 }

If no callback is provided, it assumes attributeName is also a function that was passed to _.chainable during construction.

    console.log transform(players).including('score').value()
    # [ { firstName: 'Bobby', lastName: 'Bouche', kills: 125, deaths: 63, shots: 128, score: 2.960689484126984 },
    #   { firstName: 'Annie', lastName: 'Smalls', kills: 201, deaths: 14, shots: 2432, score: 14.439790883458647 },
    #   { firstName: 'Jacob', lastName: 'Jones', kills: 101, deaths: 188, shots: 201, score: 1.0397216047422462 } ]

## Why would I use chaining vs composition



If you’ve got questions, suggestions or want to grab the source check out this gist: https://gist.github.com/aesnyder/9923d5be47cfbc8a1e38
