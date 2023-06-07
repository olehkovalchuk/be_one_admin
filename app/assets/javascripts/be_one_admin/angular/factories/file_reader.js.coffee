((module) ->

  fileReader = ($q, $log) ->

    onLoad = (reader, deferred, scope) ->
      ->
        scope.$apply ->
          deferred.resolve reader.result
          return
        return

    onError = (reader, deferred, scope) ->
      ->
        scope.$apply ->
          deferred.reject reader.result
          return
        return

    onProgress = (reader, scope) ->
      (event) ->
        scope.$broadcast 'fileProgress',
          total: event.total
          loaded: event.loaded
        return

    getReader = (deferred, scope) ->
      reader = new FileReader
      reader.onload = onLoad(reader, deferred, scope)
      reader.onerror = onError(reader, deferred, scope)
      reader.onprogress = onProgress(reader, scope)
      reader

    readAsDataURL = (file, scope) ->
      deferred = $q.defer()
      reader = getReader(deferred, scope)
      console.log(file)
      reader.readAsDataURL file
      deferred.promise

    { readAsDataUrl: readAsDataURL }

  module.factory 'fileReader', [
    '$q'
    '$log'
    fileReader
  ]
  return
) AdminApp