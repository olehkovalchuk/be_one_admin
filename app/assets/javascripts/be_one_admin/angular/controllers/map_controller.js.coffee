AdminApp.controller "MapController", [
  "$scope"
  "NgMap"
  "$rootScope"
  "$timeout"
  ($scope,NgMap,$rootScope,$timeout) ->
    vm = this

    $timeout( (->
      NgMap.getMap().then (map) ->
        vm.map = map
        $scope.markerPosition = "#{$scope.$parent.editedItem.latitude},#{$scope.$parent.editedItem.longitude}"

    ), 3000)



    $scope.getLocation = ->
      NgMap.getGeoLocation($scope.address).then ((result) ->
        $scope.$parent.editedItem.latitude = result.lat()
        $scope.$parent.editedItem.longitude = result.lng()
        $scope.markerPosition = "#{result.lat()},#{result.lng()}"
        vm.map.setZoom(16);

        return
      ), (error) ->
        $rootScope.message(error.message, true)



    $scope.getCurrentLocation = (event) ->
      $scope.$parent.editedItem.latitude = event.latLng.lat()
      $scope.$parent.editedItem.longitude = event.latLng.lng()




      console.log(event)


]
