#= require ./base_controller
AdminApp.controller "LogController", [
  "$scope"
  "$element"
  "$controller"
  "$translate"
  ($scope,$element,$controller,$translate) ->
    # Initialize the super class and extend it.

    defaultDate = moment(new Date()).startOf("day").format('DD.MM.YYYY')

    $scope.filters = {created_at: defaultDate}
    $.extend this, $controller('BeOneBaseController', $scope: $scope,$element: $element)

]
