AdminApp.filter 'contains', ->
  (array, needle) ->
    array.indexOf(needle) >= 0
