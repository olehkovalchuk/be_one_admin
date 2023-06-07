AdminApp.directive 'onEnter', ->
  (scope, element, attrs) ->
    element.bind 'keydown keypress', (event) ->
      if event.which == 13
        scope.$apply ->
          scope.$eval attrs.onEnter
          return
        event.preventDefault()
      return
    return
