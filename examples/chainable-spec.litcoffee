    _ = require('lodash')
    require('../src/chainable.litcoffee')(_)

    describe 'chainable', ->

#Chainable Transformers in Angular.js

##### \_.chainable aims to answer many of the downsides of a collection-less library like angular.js.

It takes an object containing methods and creates a new underscore instance with your methods attached. This means you can use any of your own methods, or any underscore methods in the chain.

First lets setup some data for a first person shooter game:

      players = [
        { firstName: 'Bobby', lastName: 'Bouche', sex: 'male', kills: 125, deaths: 63, shots: 128  }
        { firstName: 'Annie', lastName: 'Smalls', sex: 'female', kills: 201, deaths: 14, shots: 2432 }
        { firstName: 'Jacob', lastName: 'Jones',  sex: 'male', kills: 101, deaths: 188, shots: 201 }
      ]

Here we create our transformer where we define the chainable method:

      transform = _.chainable
        rank: (players) ->
          _.random(1, players.length)
        kdr: (p) ->
          p.kills / p.deaths
        accuracy: (p) ->
          p.kills / p.shots
        score: (p) ->
          @kdr(p) + @accuracy(p)

\_.chainable adds two extra methods:

Attr, which is a simple method for accessing object attributes.

      it 'should return the correct attribute', ->
        expect transform(players).max('kills').attr('firstName').value()
          .toEqual 'Annie'

Including takes either an object or an array, an attribute name, and an optional callback method

The object -- or each object in the array -- is then extended with the attribute name and the result of calling the callback method on (each) object.

      it 'should allow including to work an anonymous callback on an array', ->
        expect(transform(players).including('fullName', (o) -> "#{o.firstName} #{o.lastName }").value()).toEqual [
          { firstName: 'Bobby', lastName: 'Bouche', fullName: "Bobby Bouche", sex: 'male', kills: 125, deaths: 63, shots: 128  }
          { firstName: 'Annie', lastName: 'Smalls', fullName: "Annie Smalls", sex: 'female', kills: 201, deaths: 14, shots: 2432 }
          { firstName: 'Jacob', lastName: 'Jones',  fullName: "Jacob Jones", sex: 'male', kills: 101, deaths: 188, shots: 201 }
        ]

      it 'allow including on a single object', ->
        expect transform(players).max('kills').including('fullName', (o) -> "#{o.firstName} #{o.lastName}").value()
          .toEqual { firstName: 'Annie', lastName: 'Smalls', fullName: "Annie Smalls", sex: 'female', kills: 201, deaths: 14, shots: 2432 }

If no callback is provided, it assumes attributeName is also a function that was passed to \_.chainable during construction.

      it 'should call an internal method if no callback is given to inlcuding', ->
        expect transform(players).including('score').value()
          .toEqual [
            { firstName: 'Bobby', lastName: 'Bouche', sex: 'male', kills: 125, deaths: 63, shots: 128, score: 2.960689484126984 },
            { firstName: 'Annie', lastName: 'Smalls', sex: 'female', kills: 201, deaths: 14, shots: 2432, score: 14.439790883458647 },
            { firstName: 'Jacob', lastName: 'Jones', sex: 'male', kills: 101, deaths: 188, shots: 201, score: 1.0397216047422462 }
          ]

## Real world scenarios

Your project manager wants to show women with their ranks.

First we'll make a small render method, in the real world we would be appending something
to the dom.

      render = (klass) ->
        (content) ->
          console.log klass, content

      transform(players)
        .including('rank')
        .where(sex: 'female')
        .tap(render('.women'))

What your project manager forgot to mention is that he doesn't want
the ranking to take men into account. Chaining makes this easy to fix

      transform(players)
        .where(sex: 'female')
        .including('rank')
        .tap(render('.women'))

Then the client sees this and loves it and they say, "oh haiii this is niiice, lets show everyone's ranking in one pane,
only men rankings in another pane, then only women's rankings in the last pane"

Again, super easy.

"lets show everyon's ranking in one pane"

      transform(players)
        .including('rank')
        .tap(render('.men-and-women'))

"only the men's ranking in another pane"

        .tap((rankedPlayers) ->
          transform(rankedPlayers)
            .where(sex: 'male')
            .including('rank')
            .tap(render('.men')))

"and only women'sranking in the last"

        .where(sex: 'female')
        .including('rank')
        .tap(render('.women'))

If you’ve got questions, suggestions or want to grab the source check out this gist: https://gist.github.com/aesnyder/9923d5be47cfbc8a1e38
