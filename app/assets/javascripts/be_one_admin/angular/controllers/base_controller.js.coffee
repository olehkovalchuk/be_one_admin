AdminApp.controller "BeOneBaseController", [
  "$scope"
  "ngTableParams"
  "$resource"
  "$element"
  "$rootScope"
  "$anchorScroll"
  "$http"
  "$timeout"
  "Config"
  "$translate"
  "$uibModal"
  "inflector"
  "$injector"
  "fileReader"
  "NgMap"
  "CompleteService"
  "$localStorage"
  "$window"
  ($scope,ngTableParams,$resource,$element,$rootScope,$anchorScroll,$http,$timeout,Config,$translate,$uibModal,inflector,$injector,fileReader,NgMap,CompleteService,$localStorage,$window) ->
    vm = this
    url = $element.data('url')
    $scope.previousItem = {}
    $scope.tagField = "id"
    formController = "#{inflector.camelize(url.replace(/\//g,"_"), true)}Controller"

    $scope.filterRelation = {}


    unwatchFilterRelation = $scope.$watch 'filterRelation', (filterRelation) ->
      unwatchFilterRelation()

      $scope.defaultFilters = angular.copy($scope.filters || {})
      angular.merge($scope.defaultFilters, filterRelation)

      relationKey = "_#{(Object.keys(filterRelation)[0] || '')}_#{Object.values(filterRelation)[0] || ''}"
      $scope.filtersStorageKey = "#{$window.location.pathname}#{relationKey}_filters"

      $localStorage.get($scope.filtersStorageKey).then (value) ->
        $scope.filters = value if angular.equals({}, $scope.filters) || $scope.filters == undefined || $scope.filters == null
        angular.merge($scope.filters, filterRelation)

    $scope.data = []
    $scope.isArray = angular.isArray
    $scope.inArray = (array,el) ->
      array.indexOf(el) >= 0

    $scope.selectedRows = {}

    $scope.$watch 'editedItem', (newValue, oldValue) ->
      $scope.editedItemClone = angular.copy $scope.editedItem unless $scope.editedItemClone?

    $scope.$watch 'perPage', (newValue, oldValue) ->
      if newValue != oldValue
        $scope.itemsTable.page(1)
        $scope.itemsTable.reload()
    $scope.DateOptions =
      # maxDate: new Date()
      showWeeks: false
      enableTime: false

    $scope.DateOptionsRange =
      showWeeks: false
      enableTime: true
      maxDate: new Date()
      minDate: new Date(2016, 1, 1)
    $scope.setRangeOptionsDefaults = ->
      _.each $scope.rangeFields, (field) ->
        $scope["DateOptionsGte#{field.capitalize()}"] = angular.copy $scope.DateOptionsRange
        $scope["DateOptionsLte#{field.capitalize()}"] = angular.copy $scope.DateOptionsRange

    $scope.setRangeOptionsDefaults()

    $scope.onChangeGte =(field)->
      $scope["DateOptionsLte#{field.capitalize()}"].minDate = if $scope.filters["#{field}_gte"] then moment( $scope.filters["#{field}_gte"], "DD.MM.YYYY")._d else  (new Date(2016, 1, 1))
    $scope.onChangeLte =(field)->
      $scope["DateOptionsGte#{field.capitalize()}"].maxDate = if $scope.filters["#{field}_lte"] then moment( $scope.filters["#{field}_lte"], "DD.MM.YYYY")._d else  (new Date())


    $scope.tableSelector = "#itemsTable" unless $scope.tableSelector
    $scope.Item = $resource("#{url}/:id.json",{},{query:{isArray:false},update:{ method:'PUT' }, childs:{ method:'GET',params: { id: '@id'},url:"#{url}/:id/childs.json" }, toggle:{ method:'GET',params: { id: '@id'},url:"#{url}/:id/toggle.json" }, step: { method:'PUT',params: { id: '@id',step:'@step'},url:"#{url}/:id/:step/step.json"},  removeAttach: { method:'POST',params: { id: '@id',attach_type:'@attach_type',attach_id: '@attach_id'},url:"#{url}/:id/remove_attach/:attach_type/:attach_id.json"} })
    $timeout( (->
      if $element.find($scope.tableSelector).length
        $scope.itemsTable = new ngTableParams(
          page: 1
          count: $scope.perPage || Config.perPage
          total: 0
        ,
          counts: []
          getData: ($defer, params) ->
            getData(params)
        )

      if $element.find('.tree-grid').length
        getData($scope.itemsTable)
    ), 100)
    setItem = (item) ->
      # w/o copy change of editedItem changes previous item
      $scope.editedItem = angular.copy item
      # vm.editedItem = item

    setItem({}) unless $scope.editedItem

    loadItems = ->
      $scope.itemsTable.reload()

    getData = (params) ->
      requestParams = { filters: $scope.filters, limit: $scope.perPage }
      requestParams = $.extend(requestParams, {page: params.page()}) if params
      requestParams = $.extend(requestParams, {sorting: params.sorting()}) if params.sorting()
      requestParams = $.extend(requestParams, $scope.additiaonalParams) if $scope.additiaonalParams
      $scope.itemsPromise = $scope.Item.query(requestParams).$promise.then(
          (response) ->
            $scope.total = response.total
            params.total(response.total) if params
            $scope.data = response.items
            vm.data = $scope.data
          ,
          (response) ->
            if 500 == response.status
              $rootScope.message $translate.instant("serverError"), true
            else
              $rootScope.message response.data.message, true
        )

    showItem = (item) ->
      $scope.Item.get {id:item.id}, (response) ->
        if response.success
          setItem response.item
          $scope.previousItem = response.item
          $scope.showForm( "#{url}/new" )
        else
          $rootScope.message response.message, true
      ->
        $rootScope.message $translate.instant("serverError"), true


    $scope.loadTags = (query, field) ->
      return $scope[field]

    $scope.showForm = (url, size) ->
      size = size or 'lg'
      $scope.modalForm = $uibModal.open(
        templateUrl: "#{url}?only_template=true"
        size: size
        backdrop: 'static'
        animation: true
      )#.result.finally(angular.noop).then(angular.noop, angular.noop)
      $scope.modalForm.opened.then (a)->
        $timeout( (->
          $rootScope.$broadcast 'setItem', $scope.editedItem
          $rootScope.$broadcast 'setIsdisabled', $scope.isDisabled
          $rootScope.$broadcast 'setIsNew', $scope.isNew
          $rootScope.$broadcast 'setAdditionalData', $scope.additionalData
        ), 50)

    $scope.pickers = {}
    $scope.openCalendar = ($event, picker, needOpen) ->
      console.log("Wefwe")
      $scope.pickers[picker] = true if needOpen is undefined || needOpen

    $scope.closeModal = ->
      $scope.$close(false) if $scope.$close
    $scope.saveCallback = (response) ->
      if response.success
        $scope.$close(false) if $scope.$close
        $scope.itemForm.$setPristine()
        $scope.itemForm.$setUntouched()
        setItem({})
        $rootScope.$broadcast 'loadItems', $scope.editedItem
        $rootScope.message(response.message)
      else
        $rootScope.message(response.message, true)
      $anchorScroll()

    $scope.history = (item) ->
      $scope.modalForm = $uibModal.open(
        templateUrl: "#{url}/history/"
        size: 'lg'
        backdrop: 'static'
        resolve:
          item: -> $scope.editedItem
      ).result.finally(angular.noop).then(angular.noop, angular.noop)

    $scope.habtmRelation = (id,type) ->
      $scope.modalForm = $uibModal.open(
        templateUrl: "#{url}/#{id}/habtm/#{type}"
        size: 'lg'
        resolve:
          item: -> $scope.editedItem
      ).result.finally(angular.noop).then(angular.noop, angular.noop)

    $scope.oneRelation = (id,type) ->
      $scope.modalForm = $uibModal.open(
        templateUrl: "#{url}/#{id}/hasone/#{type}"
        size: 'lg'
        resolve:
          item: -> $scope.editedItem
      ).result.finally(angular.noop).then(angular.noop, angular.noop)


    $scope.manyRelation = (id,type,additionalData) ->
      $scope.additionalData = additionalData or {}
      $scope.modalForm = $uibModal.open(
        templateUrl: "#{url}/#{id}/many/#{type}"
        size: 'lg'
        resolve:
          item: -> $scope.editedItem
      )
      $scope.modalForm.opened.then (a)->
        $timeout( (->
          $rootScope.$broadcast 'setAdditionalData', $scope.additionalData
        ), 50)
    $scope.new = (foreignKey, foreignKeyValue, additionalData) ->
      foreignKey = foreignKey or false
      additionalData = additionalData or {}
      $scope.isRelation = foreignKey
      $scope.isDisabled = false
      $scope.additionalData = additionalData
      $scope.isNew = true
      item = {}
      item[foreignKey] = foreignKeyValue if foreignKey
      setItem( $scope.editedItemHtml || item )
      $scope.showForm( "#{url}/new" )

    $scope.show = (item) ->
      item = item || getItem()
      console.log(item)
      $scope.isNew = false
      $scope.isDisabled = true
      showItem item


    $scope.update = (item) ->
      item = item || getItem()
      $scope.isNew = false
      $scope.isDisabled = false
      showItem item


    $scope.toggle = (item) ->
      $scope.isNew = false
      $scope.Item.toggle {id:item.id}, (response) ->
        if response.success
          $scope.itemsTable.reload()
        else
          $rootScope.message response.message, true
      ->
        $rootScope.message $translate.instant("serverError"), true


    $scope.get = (item) ->
      $scope.isNew = false
      return if $scope.inProgress
      $scope.inProgress = true
      $scope.Item.get {id:item.id}, (response) ->
        $scope.inProgress = false
        if response.success
          setItem response.item
        else
          $rootScope.message response.message, true
      ->
        $rootScope.message $translate.instant("serverError"), true

    $scope.destroy = () ->
      item = getItem()
      $rootScope.confirm($translate.instant("deleteTextConfirm").replace('%id%', item[$scope.deleteProperty])).then ((result) ->
        $rootScope.showLoader()
        $scope.Item.delete {id:item.id}, (resp) ->
          $rootScope.message(resp.message, !resp.success)
          if resp.success
            $scope.destroyCallback()
          $anchorScroll()
      )

    $scope.removeAttach = (attach) ->
      item = $scope.editedItem
      $rootScope.confirm($translate.instant("deleteTextConfirm").replace('%id%', 'Attachment')).then ((result) ->
        $rootScope.showLoader()
        $scope.Item.removeAttach {id:item.id,attach_type: attach.type, attach_id: attach.id}, (response) ->
          if response.success
            $scope.get(item)
          else
            $rootScope.message response.message, true
      )

    $scope.destroyCallback = ->
      loadItems()

    $scope.beforeSave = ->
    $scope.resetForm = ->
      this.$watch 'previousItem', (newValue) ->
      $scope.previousItem = {} if $rootScope.isNew
      setItem $scope.previousItem
      $scope.itemForm.$setPristine()

    $scope.save = ->
      
      beforeSave()
      $scope.beforeSave()
      oldItem = angular.copy $scope.editedItem
      console.log($scope.editedItem)
      $timeout( (->
        saveItem = angular.copy $scope.editedItem
        angular.forEach saveItem, ((value,key) ->
          if $scope.previousItem[key] == saveItem[key]
            delete(saveItem[key]) unless "active" != key && saveItem[key]
          unless $scope.leftNilValues

            if !isNaN(value) and (value && !Array.isArray(value) && angular.isNumber(+value))
              console.log(key)
              if key not in ["description"]
                value = Number( value )
              saveItem[key] = value

          )
        $scope.itemForm.$setSubmitted()
        if $scope.itemForm.$valid
          $rootScope.showLoader()

          if saveItem.id
            if $scope.loadStep
              $scope.Item.step {id:saveItem.id,step: $scope.loadStep},{item:saveItem}, (response) ->
                $scope.saveCallback(response)
              , ->
                $rootScope.message($translate.instant("serverError"), true)
            else
              $scope.Item.update {id:saveItem.id},{item:saveItem}, (response) ->
                $scope.saveCallback(response)
              , ->
                $rootScope.message($translate.instant("serverError"), true)
          else
            if $scope.stepOnCreate && $scope.loadStep
              $scope.Item.step {id:saveItem.id,step: $scope.loadStep},{item:saveItem}, (response) ->
                $scope.saveCallback(response)
              , ->
                $rootScope.message($translate.instant("serverError"), true)
            else
              $scope.Item.save {item:saveItem}, (response) ->
                $scope.saveCallback(response)
              , ->
                $rootScope.message($translate.instant("serverError"), true)
                return
      ), 100)
      return

    beforeSave = ->
      angular.forEach Object.keys($scope.editedItem), ((key) ->
        if /_tags/.test(key)
          $scope.editedItem[key.replace("_tags", "")] = $scope.editedItem[key].map((tag) ->
            if tag[$scope.tagField] then tag[$scope.tagField] else tag.text
          )
          delete $scope.editedItem[key]
        if /_ids/.test(key)
          $scope.editedItem[key] = Object.keys(_.pick($scope.editedItem[key.replace("_ids", "")], (value, key) ->
            value
          ));
          delete $scope.editedItem[key.replace("_ids", "")]
          unless Array.isArray($scope.editedItem[key])
            $scope.editedItem[key] = [$scope.editedItem[key]] if $scope.editedItem[key]
        if /_base64_data/.test(key)
          delete $scope.editedItem[key.replace("_base64_data", "")]
      )

    getItem = ->
      for i in $scope.data
        return i if $scope.selectedRows[i.id]

    $scope.hasSelected = false
    $scope.$watchCollection 'selectedRows', (newValue, oldValue) ->
      $scope.hasSelected = false
      for i of $scope.selectedRows
        newValue[i] = false if oldValue[i]
        $scope.hasSelected = true if newValue[i]

    $scope.toogleCheck = (property, checked) ->
      checked = checked || false
      ids = $scope.map $element.find(".#{property}"), (el) ->
        angular.element(el).data("key")
      $scope.each ids, (value, key, obj) ->
        $scope.editedItem[property][value] = checked

    $scope.loadAutoCompleteItems = (url, query, additionalParams) ->
      additionalParams = if Array.isArray(additionalParams) then additionalParams else [String(additionalParams)]
      params = {query: query}
      for i in additionalParams
        params[i] = $scope.editedItem[i] if $scope.editedItem.hasOwnProperty(i)
      CompleteService.getItems(url, params)


    $scope.filter = ->
      angular.forEach $scope.filters, ((value,key) ->
        delete($scope.filters[key]) unless typeof($scope.filters[key]) == 'number' || $scope.filters[key]
      )
      $localStorage.set($scope.filtersStorageKey, $scope.filters)

      $scope.itemsTable.page(1)
      $scope.itemsTable.reload()

    $scope.resetFilter = ->
      $scope.itemsTable.page(1) if $scope.itemsTable?
      $scope.filters = angular.copy $scope.defaultFilters
      $scope.itemsTable.sorting({})
      $localStorage.set($scope.filtersStorageKey, $scope.filters)
      $scope.itemsTable.reload() if $scope.itemsTable?
      $scope.setRangeOptionsDefaults()

    $scope.getFile = ->
      $scope.progress = 0
      angular.forEach ($element.data('logo') || []), ((value,key) ->
        fileReader.readAsDataUrl($scope[value], $scope).then (result) ->
          $scope.editedItem["#{value}_base64_data"] = result
          $scope.editedItem[value] = result
          return
        return
      )


    $scope.menuOptions = []
    $timeout( (->
      $scope.each $scope.allowedActions, (val, key) ->
        action =
          html: "<a class='context-item' href='#'><i class='fa fa-#{val}'></i> &nbsp;#{$translate.instant(key)}</a>"
          click: ($itemScope, $event, modelValue, text, $li) ->
            $scope[key]($itemScope.item)
        $scope.menuOptions.push(action)
    ), 100)

    $scope.pageChanged = ->
      $scope.itemsTable.page($scope.currentPage)
      getData($scope.itemsTable)

    $scope.expandTree = (item) ->
      $scope.Item.childs {id:item.id}, (response) ->
        if response.success
          item.children = response.items
        else
          $rootScope.message response.message, true
      ->
        $rootScope.message $translate.instant("serverError"), true
    $scope.setNested = (id, baseItems, nestedItems) ->
      _series = []
      angular.forEach $scope[baseItems], ((item) ->
        first = if $.isNumeric( item.id ) then Number( item.id ) else String( item.id )
        second = if $.isNumeric( id ) then Number( id ) else String( id )
        _series = (item.items or []) if first == second
      )
      $scope[nestedItems] = _series

    $scope.$on 'setItem', (event, data) ->
      $scope.editedItem = $scope.editedItemHtml || data
      $scope.previousItem = angular.copy $scope.editedItem
      # vm.editedItem = $scope.editedItemHtml || data

    $scope.$on 'setIsdisabled', (event, data) ->
      $scope.isDisabled =  data

    $scope.$on 'setIsNew', (event, data) ->
      $rootScope.isNew = data

    $scope.$on 'setAdditionalData', (event, data) ->
      $scope.additionalData =  data

    $scope.$on 'loadItems', (event, data) ->
      loadItems() if $scope.itemsTable

    $timeout( (->
      if $scope.editedItemHtml && $scope.isNew && !$scope.isRelation
        $scope.editedItem = $scope.editedItemHtml
        # vm.editedItem = $scope.editedItemHtml
    ), 100)


    vm.show = $scope.show
    vm.update = $scope.update
    vm.destroy = $scope.destroy
    vm.manyRelation = $scope.manyRelation
    vm.habtmRelation = $scope.habtmRelation
    vm.oneRelation = $scope.oneRelation


    $scope.ifExist = (func, params, refresh) ->
      if($scope[func] is undefined)
        params = params  || {}
        refresh = refresh || false
        $scope[func] = (item) ->
          item = item || getItem()
          $http(
            method: 'POST'
            params: params
            url: "#{$element.data('url')}/#{item.id}/#{func}.json").then ((response) ->
            if response.data.success
              $rootScope.message response.data.message
              if refresh
                $window.location.reload()
              else
                $scope.itemsTable.reload()
            else
              $rootScope.message response.data.message, true
            return
          ), (response) ->
            $rootScope.message $translate.instant("serverError"), true

      true

    $scope.ifExistCollection = (func, params, refresh) ->
      if($scope[func] is undefined)
        params = params  || {}
        refresh = refresh || false
        $scope[func] = () ->
          $http(
            method: 'POST'
            params: params
            url: "#{$element.data('url')}/#{func}.json").then ((response) ->
            if response.data.success
              $rootScope.message response.data.message
              if refresh
                $window.location.reload()
              else
                $scope.itemsTable.reload()
            else
              $rootScope.message response.data.message, true
            return
          ), (response) ->
            $rootScope.message $translate.instant("serverError"), true

      true


    $scope.export = ->
      delete $scope.filters[$scope.filtersStorageKey]
      unless $scope.filters.created_at_gte && $scope.filters.created_at_lte
        return $rootScope.message($translate.instant('needChooseInterval'), true)

      createdAtLte = moment($scope.filters.created_at_lte, 'YYYY-MM-DD')
      createdAtGte = moment($scope.filters.created_at_gte, 'YYYY-MM-DD')
      if moment.duration(createdAtLte.diff(createdAtGte)).asDays() > 30
        return $rootScope.message($translate.instant('needChooseLessInterval'), true)

      $rootScope.confirm($translate.instant('exportTextConfirm')).then ->
        $window.open("#{url}/export?#{$window.serialize($scope.filters)}")



    return this
]
