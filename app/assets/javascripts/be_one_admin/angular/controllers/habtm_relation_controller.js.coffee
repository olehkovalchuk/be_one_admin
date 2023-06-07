AdminApp.controller "HabtmRelationController", [
  "$scope"
  "$element"
  "$http"
  "$rootScope"
  ($scope, $element, $http, $rootScope) ->
    itemsA = []
    itemsB = []
    arrayObjectIndexOf = (myArray, searchTerm, property) ->
      i = 0
      len = myArray.length
      while i < len
        if myArray[i][property] == searchTerm
          return i
        i++
      -1

    loadItems = (id) ->
      $http(
        method: 'GET'
        url: "#{$element.data('url')}.json").then ((response) ->
        if response.data.success
          $scope.listA = angular.copy( response.data.available )
          $scope.listB = angular.copy( response.data.exists )
          $scope.items = angular.copy( response.data.available.concat( response.data.exists ) )
        else
          $rootScope.message response.data.message
        return
      ), (response) ->
        $rootScope.message $rootScope.serverError, true

    reset = ->
      $scope.selectedA = []
      $scope.selectedB = []
      $scope.toggle = 0

    $scope.selectedA = []
    $scope.selectedB = []

    $scope.checkedA = false
    $scope.checkedB = false

    $scope.closeModal = ->
      $scope.$close(false) if $scope.$close

    $scope.aToB = ->
      $scope.selectedA.forEach (i) ->
        delId = arrayObjectIndexOf($scope.listA, i, 'id')
        $scope.listB = $scope.listB.concat($scope.listA.splice( delId, 1))
      reset()

    $scope.bToA = ->
      $scope.selectedB.forEach (i) ->
        delId = arrayObjectIndexOf($scope.listB, i, 'id')
        $scope.listA = $scope.listA.concat($scope.listB.splice( delId, 1))
      reset()


    $scope.toggleA = ->
      if $scope.selectedA.length > 0
        $scope.selectedA = []
      else
        for i of $scope.listA
          $scope.selectedA.push $scope.listA[i].id
      return

    $scope.toggleB = ->
      if $scope.selectedB.length > 0
        $scope.selectedB = []
      else
        for i of $scope.listB
          $scope.selectedB.push $scope.listB[i].id
      return

    $scope.dropped = (dragId, dropId) ->
      dragEl = document.getElementById(dragId)
      dropEl = document.getElementById(dropId)

      return


    $scope.drop = (event, direction) ->

      drag = angular.element(event.dragEl)
      drop = angular.element(event.dropEl)
      id = drag.attr('data-id')
      el = document.getElementById(id)
      if !angular.element(el).attr('checked')
        angular.element(el).triggerHandler 'click'
      direction()
      $scope.bToA();
      $scope.$digest()
      return


    $scope.$watch 'listB', (newValue, oldValue) ->
      if newValue != undefined && oldValue != undefined
        if newValue.length != oldValue.length
          ids = newValue.map((item) ->
            item.id
          )
          $http(
            method: 'POST'
            data: {ids: ids}
            url: "#{$element.data('url').replace('relation','update_relation')}").then ((response) ->
            unless response.data.success
              $rootScope.message response.data.message
          ), (response) ->
            $rootScope.message $rootScope.serverError, true
    , true
    loadItems()




]
