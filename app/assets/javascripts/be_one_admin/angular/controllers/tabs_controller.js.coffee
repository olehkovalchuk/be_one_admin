AdminApp.controller "TabsController", [
  "$scope"
  ($scope) ->
    $scope.steps =
      1:true
    $scope.toggleTab = (idx) ->
      angular.forEach $scope.steps, ((value,key) ->
        $scope.steps[key] = false
        )
      $scope.steps[idx] = true
]
