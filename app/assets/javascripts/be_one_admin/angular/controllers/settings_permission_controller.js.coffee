#= require ./base_controller
AdminApp.controller "SettingsPermissionController", [
  "$scope"
  "$element"
  "$controller"
  "$timeout"
  ($scope,$element,$controller,$timeout) ->
    # Initialize the super class and extend it.
    $.extend this, $controller('BeOneBaseController', $scope: $scope,$element: $element)

    $scope.loadTags = (query) ->
      $scope.modulesActions[$scope.editedItem.controller] || []

]
