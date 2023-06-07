#= require ../vendor/moment-with-locales
#= require ../vendor/moment-range

$(document).on 'turbolinks:load', ->
  moment.locale(document.getElementsByTagName('html')[0].getAttribute('lang') || 'en', {
    week: {
      dow: 0
    }
  });
