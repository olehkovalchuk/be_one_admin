AdminApp.controller "ModalFormController", [
  "$scope"
  "$uibModalInstance"
  "$rootScope"
  "item"
  ($scope,$uibModalInstance,$rootScope,item) ->

    $scope.confirm = ->
      $uibModalInstance.close(item)
    $scope.cancel = ->
      $uibModalInstance.dismiss "cancel"

]
