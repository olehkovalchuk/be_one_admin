AdminApp.directive 'convertToNumber', ->
  {
    require: 'ngModel'
    link: (scope, element, attrs, ngModel) ->
      ngModel.$parsers.push (val) ->
        if val != null then parseInt(val, 10) else null
      ngModel.$formatters.push (val) ->
        if val != null then '' + val else null
      return

  }