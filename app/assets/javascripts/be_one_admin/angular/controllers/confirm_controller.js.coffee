AdminApp.controller "ConfirmController", [
  "$scope"
  "$uibModalInstance"
  "params"
  ($scope,$uibModalInstance,params) ->
    $scope.title = params.title
    $scope.text  = params.text
    $scope.class = params.class
    $scope.isConirm = params.confirm
    $scope.confirm = (data) ->
      $uibModalInstance.close(data)
    $scope.cancel = ->
      $uibModalInstance.dismiss()
]
