AdminApp.filter 'isempty', ->
  (input, replaceText) ->
    if input
      return input
    replaceText