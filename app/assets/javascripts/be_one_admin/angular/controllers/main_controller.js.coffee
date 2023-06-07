AdminApp.controller 'MainController', [
  '$scope'
  '$timeout'
  '$element'
  '$window'
  '$cookies'
  ($scope, $timeout, $element, $window, $cookies) ->
    $scope.minifedSidebar = false
    $scope.showUserMenu = false
    $scope.showNotificationMenu = false
    $scope.readedNotifications = []
    $scope.locale = $cookies.get('locale') || 'en'

    $scope.userMenuToogle = ->
      $scope.showUserMenu = !$scope.showUserMenu

    $scope.leftSidebar =
      setCurrentLink: ->
        path = window.location.pathname.split('/')
        path.shift()
        $scope.activeLink = "/" + path.join("/")
        index = path.indexOf($window.appConfig.path)
        if index > -1
          path.splice(0,1)
        $scope.activeModule = path[0]

    $scope.showNotification = (id) ->
      $scope.processForm(
        "#{$element.data('notificationUrl')}/#{id}",
        false,
        (response) ->
          $scope.message response.item.notification_text, !response.success, response.item.notification_heading
          if response.success
            $timeout (->
              $scope.readedNotifications.push Number(id)
            ), 2000
        ,
        'GET'
      )

    $scope.changeLocale = ->
      $cookies.put('locale', $scope.locale, { path: '/' })
      location.reload();

]
