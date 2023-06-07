AdminApp.controller 'fileUploadCtrl', [
  '$scope'
  ($scope) ->
]
AdminApp.directive 'imgUpload', ($http, $compile) ->
  {
    restrict: 'AE'
    scope:
      url: '@'
      method: '@'
      files: '='
    template: '<input class="fileUpload" type="file" multiple />' + '<div class="dropzone">' + '<p class="msg">Click or Drag and Drop files to upload</p>' + '</div>' + '<div class="preview row">' + '<div class="previewData col-md-3" ng-repeat="data in previewData track by $index">' + '<img src="{{set_image_path(data)}}"></img>' + '<span ng-click="remove(data)" class="circle remove">' + '<i class="fa fa-close"></i>' + '</span>' + '<div class="previewDetails">' + '<div class="detail">{{data.name}}, {{data.size}}</div>'+ '</div>' + '</div>' + '</div>'
    link: (scope, elem, attrs) ->
      formData = new FormData
      scope.files = scope.files || []
      previewFile = (file) ->
        reader = new FileReader
        obj = (new FormData).append('file', file)

        reader.onload = (data) ->
          src = data.target.result
          size = if file.size / (1024 * 1024) > 1 then (file.size / (1024 * 1024)).toFixed(2) + ' mB' else (file.size / 1024).toFixed(2) + ' kB'
          scope.$apply ->
            scope.files = scope.files || []
            scope.files.push src
            scope.previewData.push
              'name': file.name
              'size': size
              'type': file.type
              'src': src
              'data': obj
            return
          return
        reader.readAsDataURL file
        return

      uploadFile = (e, type) ->
        e.preventDefault()
        files = ''
        if type == 'formControl'
          files = e.target.files
        else if type == 'drop'
          files = e.originalEvent.dataTransfer.files
        i = 0
        while i < files.length
          file = files[i]
          if !['jpg', 'jpeg', 'png', 'plain', 'msword', 'pdf'].includes(file.type.split("/")[1])
            alert "Wrong file format!"
          else
            previewFile file
          i++
        return

      scope.previewData = []
      elem.find('.fileUpload').bind 'change', (e) ->
        uploadFile e, 'formControl'
        return
      elem.find('.dropzone').bind 'click', (e) ->
        $compile(elem.find('.fileUpload'))(scope).trigger 'click'
        return
      elem.find('.dropzone').bind 'dragover', (e) ->
        e.preventDefault()
        return
      elem.find('.dropzone').bind 'drop', (e) ->
        uploadFile e, 'drop'
        return

      scope.set_image_path = (data) ->
        if data.type.indexOf("image") == -1
          return "https://cdn3.iconfinder.com/data/icons/files-44/32/File_Link-512.png"
        else
          return data.src

      scope.upload = (obj) ->
        $http(
          method: scope.method
          url: scope.url
          data: obj.data
          headers: 'Content-Type': undefined
          transformRequest: angular.identity).success (data) ->
        return

      scope.remove = (data) ->
        index = scope.previewData.indexOf(data)
        scope.previewData.splice index, 1
        index = scope.files.indexOf(data)
        scope.files.splice index, 1
        return

      return

  }
