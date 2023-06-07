#timestamp formatter
AdminApp.filter 'byFormat', ->
  (input) ->
    moment.unix(input.timestamp).format(input.format)
