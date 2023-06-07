AdminApp.directive 'stringToNumber', ->
  {
  require: 'ngModel'
  link: (scope, element, attrs, ngModel) ->
    ngModel.$parsers.push (value) ->
      '' + value
    ngModel.$formatters.push (value) ->
      parseFloat value, 10
    return

  }