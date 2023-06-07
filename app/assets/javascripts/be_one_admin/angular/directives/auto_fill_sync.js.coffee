AdminApp.directive 'autoFillSync', ($timeout) ->
  {
    require: 'ngModel'
    link: (scope, elem, attrs, ngModel) ->
      origVal = elem.val()

      $timeout (->
        newVal = elem.val()
        if ngModel.$pristine and origVal != newVal
          ngModel.$setViewValue newVal
        return
      ), 500

      return

  }