AdminApp.filter 'asDate', ->
  (input) ->
    new Date(input * 1000)