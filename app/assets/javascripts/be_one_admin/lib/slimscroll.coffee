#= require ../vendor/jquery.slimscroll.min

$(document).on 'turbolinks:load', ->
  $('[data-scrollbar]').each ->
    $(this).slimScroll
      height: '100%'
      position: if this.dataset.scrollbar == 'left' then 'left' else 'right'
