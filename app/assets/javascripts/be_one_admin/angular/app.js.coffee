window.AdminApp = angular.module("BeOneAdmin", [
  "ngRoute"
  "ngResource"
  "ngAnimate"
  "ngSanitize"
  'ngCookies'
  "ui.bootstrap"
  "ui.tree"
  "templates"
  "ngTable"
  "NgSwitchery"
  'pascalprecht.translate'
  'ui.bootstrap.contextMenu'
  'ngTagsInput'
  'platanus.inflector'
  'ui.utils.masks'
  'lvl.directives.dragdrop'
  'ui.bootstrap.datetimepicker'
  'ngMap',
  'ui.multiselect'
  'daterangepicker'
  'treeGrid'
  'angularFileUpload'
  'angular-underscore',
  'ui.mask',
  'ngLocalStorage',
  'ui.select'
])

AdminApp.run [
    "$location"
    "$rootElement"
    "$rootScope"
    "$timeout"
    "$http"
    "$uibModal"
    "$compile"
    "$injector"
    ($location, $rootElement,$rootScope,$timeout,$http,$uibModal,$compile,$injector) ->

      $rootElement.off "click"
      $rootScope.serverError = "Server Error"
      $rootScope.availableLocales = angular.copy window.availableLocales;

      $rootScope.message = (text,isError,title) ->
        title = title or "Message"
        data =
          title: title
          text: text
          class: (if isError then 'danger' else 'success')
          confirm: false

        $uibModal.open(
          templateUrl: "be_one_admin/angular/templates/confirmModal.html"
          controller: "ConfirmController"
          resolve:
            params: -> data
        ).result.finally(angular.noop).then(angular.noop, angular.noop)
      $rootScope.confirm = (text, template) ->
        title = "Confirm"
        data =
          title: title
          text: text
          class: 'warning'
          confirm: true
        $uibModal.open(
          templateUrl: (template || "be_one_admin/angular/templates/confirmModal.html")
          controller: "ConfirmController"
          resolve:
            params: -> data
        ).result
      $rootScope.processForm = (url, formData, successAction, method) ->
        formData = formData or {}
        method = method or "POST"
        successAction = successAction or ->
        $http(
          method: method
          url: url
          data: $.param(formData)
          headers: 'Content-Type': 'application/x-www-form-urlencoded').then ((response) ->
          if response.data.status || response.data.success
            successAction(response.data)
          else
            $rootScope.message response.data.message
          return
        ), (response) ->
          $rootScope.message $rootScope.serverError, true

      $rootScope.showLoader = ->
        Pace.restart()

      loadPluguns = ->
        # $rootScope.updateSelect()
        # angular.forEach angular.element("[data-switchery]"), (elem) -> new Switchery(elem)

      loadPluguns()

  ]
# This will cause your app to compile when Turbolinks loads a new page
# and removes the need for ng-app in the DOM
$(document).on 'turbolinks:load', (args) ->
  angular.bootstrap document.body, [ 'BeOneAdmin' ]
  return
