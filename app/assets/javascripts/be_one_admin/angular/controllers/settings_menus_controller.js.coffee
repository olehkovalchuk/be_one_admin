#= require ./base_controller
AdminApp.controller "SettingsMenusController", [
  "$scope"
  "ngTableParams"
  "$resource"
  "$element"
  "$rootScope"
  "$anchorScroll"
  "$http"
  "$timeout"
  "Config"
  "$translate"
  '$controller'
  ($scope,ngTableParams,$resource,$element,$rootScope,$anchorScroll,$http,$timeout,Config,$translate,$controller) ->
    # Initialize the super class and extend it.
    $.extend this, $controller('BeOneBaseController', $scope: $scope,$element: $element)
    $scope.data = []
    url = $element.data("url")
    $scope.Item = $resource("#{url}/:id.json",{},{query:{isArray:false},update:{ method:'PUT' }, move:{ method:'PATCH',params:{id: '@id'},url:"#{url}/:id/move" }})
    loadMenu = ->
      $scope.Item.query( (response)->
        if response.success
          $scope.data = response.menu
      ->
        $rootScope.message $rootScope.serverError, true
      )

    movePosition = ( id, up ) ->
      up = up or false
      $rootScope.confirm($translate.instant("changePositionConfirm")).then ((result) ->
        $rootScope.showLoader()
        $scope.Item.move {id:id,up:up}, (resp) ->
          $rootScope.message(resp.message, !resp.success)
          if resp.success
            loadMenu()
        $anchorScroll()
      )
    $scope.saveCallback = (response) ->
      loadMenu()
      $rootScope.message response.message
    $scope.reload = ->
      loadMenu()
    $scope.resetForm = ->
      $scope.editedItem =  {}
      $scope.itemForm.$setPristine()

    getItem = ->
      return $scope.nodeItem



    $scope.menuOptions = [
      [
        $translate.instant("up")
        ($itemScope) ->
          movePosition $itemScope.node.id, true
          return
      ]
      null
      [
        $translate.instant("down")
        ($itemScope) ->
          movePosition $itemScope.node.id
      ]
      null
      [
        $translate.instant("update")
        ($itemScope) ->
          $scope.update($itemScope.node)
      ]
      null
      [
        $translate.instant("delete")
        ($itemScope) ->
          $rootScope.confirm($translate.instant("deleteTextConfirm")).then ((result) ->
            $rootScope.showLoader()
            $scope.Item.delete {id:$itemScope.node.id}, (resp) ->
              $rootScope.message(resp.message, !resp.success)
              if resp.success
                loadMenu()
            $anchorScroll()
          )
      ]
    ]

    loadMenu()

]
