AdminApp.filter 'range', ->
  (input, min, max) ->
    min = parseInt(min)
    #Make string input int
    max = parseInt(max)
    i = min
    while i < max
      input.push i
      i++
    input