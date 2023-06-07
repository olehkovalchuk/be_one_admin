AdminApp.controller "FlashMessagesController", [
  "$scope"
  "$attrs"
  "$timeout"
  "$rootScope"
  ($scope,$attrs,$timeout,$rootScope) ->
    $timeout( (->
      flash = angular.fromJson $attrs.initial
      if $attrs.initial.length
        if flash.message
          $rootScope.message(flash.message)
        else if flash.error
          $rootScope.message(flash.error, true)
    ), 1000)


]
