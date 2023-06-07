AdminApp.directive 'initialValue', [
  '$timeout'
  ($timeout) ->
    link: ($scope, $element, $attrs) ->
      return unless $attrs.initialValue && $attrs.ngModel && $scope.$eval($attrs.ngModel) == undefined

      $timeout (->
        $scope.$eval($attrs.ngModel + ' = ' + $attrs.initialValue) if $scope.$eval($attrs.ngModel) == undefined
      ), 100

      return
]
