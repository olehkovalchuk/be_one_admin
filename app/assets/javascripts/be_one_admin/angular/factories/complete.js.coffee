AdminApp.service 'CompleteService', [
  '$http'
  ($http) ->
    @items = []
    @getItems = (type,query) ->
      params = if typeof query is 'object' then query else {query: query}
      $http.get("/directories/complete/#{type}.json", params: params).then (res) ->
        return res.data
    return
]
