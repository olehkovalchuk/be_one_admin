AdminApp.directive 'mceEditor', [
  '$parse'
  "$timeout"
  ($parse,$timeout) ->
    link: ($scope, $element, $attrs) ->
      return unless $attrs.mceEditor

      tinyMCE.execCommand 'mceRemoveEditor', true, $attrs.id

      plugins = 'code print preview searchreplace autolink directionality visualblocks visualchars fullscreen image link media template codesample table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount imagetools textpattern help'
      plugins = plugins + ' fullpage' if $attrs.fullPage
      tinymce.init
        target: $element[0]
        plugins: plugins
        toolbar: 'formatselect | bold italic strikethrough forecolor backcolor permanentpen formatpainter | link image media pageembed | alignleft aligncenter alignright alignjustify  | numlist bullist outdent indent | removeformat | addcomment'
        image_advtab: true
        content_css: [
          '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i'
          '//www.tiny.cloud/css/codepen.min.css'
        ]
        image_class_list: [
          {
            title: 'None'
            value: ''
          }
          {
            title: 'Left'
            value: 'post__pic post__pic_left'
          }
          {
            title: 'Right'
            value: 'post__pic post__pic_right'
          }
        ]
        importcss_append: true
        height: 400
        template_cdate_format: '[CDATE: %m/%d/%Y : %H:%M:%S]'
        template_mdate_format: '[MDATE: %m/%d/%Y : %H:%M:%S]'
        image_caption: true
        spellchecker_dialog: true
        images_upload_url: "/" + window.appConfig.path + '/uploads/images'
        images_upload_handler: (blobInfo, success, failure) ->
          xhr = undefined
          formData = undefined
          xhr = new XMLHttpRequest
          xhr.withCredentials = false
          xhr.open 'POST', "/" + window.appConfig.path + '/uploads/images'

          xhr.onload = ->
            json = undefined
            if xhr.status != 200
              failure 'HTTP Error: ' + xhr.status
              return
            json = JSON.parse(xhr.responseText)
            if !json or typeof json.location != 'string'
              failure 'Invalid JSON: ' + xhr.responseText
              return
            success json.location
            return

          formData = new FormData
          formData.append 'file', blobInfo.blob(), blobInfo.filename()
          xhr.send formData
          return
        spellchecker_whitelist: [
          'Ephox'
          'Moxiecode'
        ]
        tinycomments_mode: 'embedded'
        content_style: '.mce-annotation { background: #fff0b7; } .tc-active-annotation {background: #ffe168; color: black; }'
        setup: (editor) ->
          unwatch = $scope.$watch $attrs.mceEditor, (value) ->
            unless value == undefined
              unwatch()
              console.log(editor.getContent())

              console.log(editor.getContent())
              
        init_instance_callback: (editor) ->
          editor.on 'Change', ->
            $parse($attrs.mceEditor).assign($scope, editor.getContent())



]


