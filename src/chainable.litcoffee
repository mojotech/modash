#_.chainable

First we create a export for the module so that we can mix into another _ instance

    module.exports = (_) ->
      _.mixin 'chainable': (obj) ->

Clone the methods given to _.chainable and extend them with _ to get access
to all of the _ methods.

        methods = _.extend _.cloneDeep(obj), _,

We add a few helper methods, the first called inlcuding.

          including: (obj, attrName, value) ->
            extObj = (o) ->

If the value is a function, call it.

              val = if _.isFunction(value)
                value.call methods, o

If no value is passed, assume this was a method passed to the constructor, and call it

              else if _.isUndefined
                methods[attrName](o)
Othwerise just use the value passed (for strings, numbers, arrays, objects etc...)

              else
                value

Finally, we extend the object with the appropriate key value pair.

              _.extend o, _.object([attrName], [val])


If operating on an array, extend each object in the array. Methods is passed as the "this" context

            if _.isArray(obj)
              _.map obj, extObj, methods

Otherwise just extend the object

            else if _.isObject(obj)
              extObj(obj)

Simple helper method for accessing attributes on objects.

          attr: (obj, metric) -> obj[metric]

We create the transformer function that is used for chaining.

        transformer = (arg) ->

Transformer always returns an object, a key component in chainability

          _.extend

We set the collector equal to a clone of the data to be transformed

            __collector: _.cloneDeep(arg)

And override underscore's value method to access our collector, instead of theirs.

            value: -> @__collector
          ,

We extend in a new hash of the user defined methods + underscore methods which will all operate on @collector.
Thus making them chainable together.

            _.mapValues methods, (method) ->
              ->
                args = _.toArray arguments
                args.unshift(@__collector)
                @__collector = method.apply(methods, args)
                this

We return the transformer function extended with the user defined and _ methods. This is how we achieve the ability to do optional chaining.
transformer(data).score().value() vs transformer.score(data)

        _.extend transformer, methods
