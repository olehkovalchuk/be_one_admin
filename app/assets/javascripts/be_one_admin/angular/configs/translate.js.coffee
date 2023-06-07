AdminApp.config ['$translateProvider', ($translateProvider) ->
    $translateProvider.translations 'en', I18n.en
    $translateProvider.preferredLanguage 'en'
  ]