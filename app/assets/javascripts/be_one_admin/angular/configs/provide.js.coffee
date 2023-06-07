AdminApp.config [
  '$provide'
  ($provide) ->
    $provide.decorator '$controller', [
      '$delegate'
      ($delegate) ->
        (constructor, locals) ->
          if typeof constructor == 'string'
            locals.$scope.controllerName = constructor
          $delegate.apply this, [].slice.call(arguments)
    ]
]
