AdminApp.directive 'ngFileSelect', ->
  { link: ($scope, el) ->
    el.bind 'change', (e) ->
      $scope[$(e.currentTarget).attr("id")] = (e.srcElement or e.target).files[0]
      $scope.getFile()
      return
    return
 }