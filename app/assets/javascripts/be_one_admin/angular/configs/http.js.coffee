AdminApp.config ['$locationProvider', ($locationProvider) ->
    $locationProvider.html5Mode
      enabled: true
      requireBase: false
  ]
  .config ["$httpProvider", ($httpProvider) ->
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
    # $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
  ]
