AdminApp.controller 'OLMapController', ['$rootScope', '$scope', '$translate', ($rootScope, $scope, $translate) ->
  $scope.map = null
  $scope.marker = null

  updateCoordinateFields = (lng, lat) ->
    document.getElementById('longitude').value = $scope.$parent.editedItem.longitude = lng
    document.getElementById('latitude').value = $scope.$parent.editedItem.latitude = lat
    return

  dragMarker = ->
    currentCoordinate = null
    pointer = 'pointer'
    currentFeature = null
    prevCursor = undefined

    ol.interaction.Pointer.call this,
      handleDownEvent: (evt) ->
        evt.map.getTargetElement().style.cursor = 'grabbing'

        if feature = evt.map.forEachFeatureAtPixel(evt.pixel, (feature) -> feature)
          currentCoordinate = evt.coordinate
          currentFeature = feature
        !!feature

      handleDragEvent: (evt) ->
        deltaX = evt.coordinate[0] - (currentCoordinate[0])
        deltaY = evt.coordinate[1] - (currentCoordinate[1])

        geometry = currentFeature.getGeometry()
        geometry.translate(deltaX, deltaY)

        currentCoordinate[0] = evt.coordinate[0]
        currentCoordinate[1] = evt.coordinate[1]
        return

      handleMoveEvent: (evt) ->
        if pointer
          feature = evt.map.forEachFeatureAtPixel evt.pixel, (feature) -> feature
          element = evt.map.getTargetElement()
          if feature
            if element.style.cursor != pointer
              prevCursor = element.style.cursor
              element.style.cursor = pointer
          else if prevCursor != undefined
            element.style.cursor = prevCursor
            prevCursor = undefined
        return

      handleUpEvent: (evt) ->
        evt.map.getTargetElement().style.cursor = 'grab'

        coordinates = ol.proj.toLonLat($scope.marker.getGeometry().getCoordinates())
        updateCoordinateFields(coordinates[0], coordinates[1])

        currentCoordinate = null
        currentFeature = null
        false
    return

  $scope.initMap = ->
    defaultCoordinates = ol.proj.fromLonLat([
      $scope.$parent.editedItem.longitude || 31.27
      $scope.$parent.editedItem.latitude || 49.49
    ])

    $scope.marker = new ol.Feature(geometry: new ol.geom.Point(defaultCoordinates))
    $scope.marker.setStyle(
      new ol.style.Style
        zIndex: 5
        image: new ol.style.Icon
          anchor: [0.5, 1],
          anchorXUnits: 'fraction',
          anchorYUnits: 'fraction',
          scale: 0.8,
          src: '/images/location-pointer.png'
    )
    markerSource = new ol.source.Vector(features: [$scope.marker])

    mapEl = document.getElementById('map')
    $scope.map = new (ol.Map)
      target: mapEl
      loadTilesWhileAnimating: true
      layers: [new ol.layer.Tile(source: new ol.source.OSM), new ol.layer.Vector(source: markerSource)]
      view: new (ol.View)
        center: defaultCoordinates
        zoom: mapEl.dataset.zoom
        minZoom: 3
        maxZoom: 20

    $scope.map.on 'moveend', ->
      mapEl.style.cursor = 'grab'
    $scope.map.on 'click', ->
      mapEl.style.cursor = 'grab'

    if mapEl.dataset.drag == 'true'
      ol.inherits(dragMarker, ol.interaction.Pointer)
      $scope.map.addInteraction(new dragMarker())
    else
      $scope.map.on 'movestart', ->
        mapEl.style.cursor = 'grabbing'

    unwatch = $scope.$watchGroup ['$parent.editedItem.longitude', '$parent.editedItem.latitude'], (values) ->
      if values[0] && values[1]
        unwatch()
        coordinates = ol.proj.fromLonLat(values)
        $scope.marker.getGeometry().setCoordinates(coordinates)
        $scope.map.getView().animate(center: coordinates, duration: 500)
      return

  $scope.getLocation = ->
    GeocoderJS.createGeocoder('openstreetmap').geocode $scope.address, (result) ->
      if result[0].latitude && result[0].longitude
        updateCoordinateFields(result[0].longitude, result[0].latitude)
        coordinates = ol.proj.fromLonLat([result[0].longitude, result[0].latitude])
        $scope.marker.getGeometry().setCoordinates(coordinates)
        $scope.map.getView().animate(center: coordinates, duration: 500)
      else
        $rootScope.message($translate.instant('unknownLocation'), true)
]
