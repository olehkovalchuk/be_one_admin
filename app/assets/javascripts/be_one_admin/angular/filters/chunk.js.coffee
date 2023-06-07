AdminApp.filter 'chunk', ->
  cacheIt = (func) ->
    cache = {}
    (arg) ->
      # if the function has been called with the argument
      # short circuit and use cached value, otherwise call the
      # cached function with the argument and save it to the cache as well then return
      if cache[arg] then cache[arg] else (cache[arg] = func(arg))

  # unchanged from your example apart from we are no longer directly returning this   ​

  chunk = (items, chunk_size) ->
    chunks = []
    if angular.isArray(items)
      if isNaN(chunk_size)
        chunk_size = 4
      i = 0
      while i < items.length
        chunks.push items.slice(i, i + chunk_size)
        i += chunk_size
    else
      console.log 'items is not an array: ' + angular.toJson(items)
    chunks

  cacheIt chunk

AdminApp.filter 'group_chunk', ->
  cacheIt = (func) ->
    cache = {}
    (arg) ->
      if cache[arg] then cache[arg] else (cache[arg] = func(arg))

  chunk = (items, chunk_size) ->
    chunks = []
    if angular.isArray(items)
      if isNaN(chunk_size)
        chunk_size = 4
      i = 0
      chunk_size = Math.ceil(items.length / chunk_size)
      while i < items.length
        chunks.push items.slice(i, i + chunk_size)
        i += chunk_size
    else
      console.log 'items is not an array: ' + angular.toJson(items)
    console.log(chunks)
    chunks
  cacheIt chunk