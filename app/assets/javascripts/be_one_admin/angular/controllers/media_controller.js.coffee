#= require ./base_controller
AdminApp.controller "MediaController", [
  "$scope"
  "$element"
  "$rootScope"
  '$controller'
  '$window'
  "CompleteService"
  "$timeout"
  "FileUploader"
  ($scope,$element,$rootScope,$controller,$window,CompleteService,$timeout,FileUploader) ->
    # Initialize the super class and extend it.
    $.extend this, $controller('BeOneBaseController', $scope: $scope,$element: $element)
    url = $element.data("url")
    uploader = $scope.uploader = new FileUploader
      url: url
      removeAfterUpload : true,
      autoUpload : true,
      headers:
        'X-CSRF-TOKEN': $('meta[name=csrf-token]').attr('content')

    uploader.onBeforeUploadItem = (item) ->
      item.formData.push($scope.fileupload)

    uploader.onCompleteItem = (fileItem, response, status, headers) ->
      angular.element('#hidden-file-input').val('')
      if response.success
        loadItems()
        $rootScope.message response.message, false
      else
        $rootScope.message response.message, true

    $scope.image_upload = ->
      angular.element('#hidden-file-input').click();


    loadItems = ->
      $scope.Item.query(
          page: $scope.page
        ).$promise.then(
          (response) ->
            $scope.total =
            $scope.images = response.items
            $scope.imageChunks = $scope.images.chunk(6)
          ,
          (response) ->
            if 500 == response.status
              $rootScope.message $translate.instant("serverError"), true
            else
              $rootScope.message response.data.message, true
        )
    $timeout( (->
      loadItems()
    ), 100)
    $scope.destroyCallback = ->
      loadItems()


    $scope.preview = (item) ->
      console.log(item)
      $scope.Item.get {id:item.id}, (response) ->
        if response.success
          $scope.editedItem = response.item
          $scope.showForm( "#{url}/preview" )
        else
          $rootScope.message response.message, true
      ->
        $rootScope.message $translate.instant("serverError"), true


]
