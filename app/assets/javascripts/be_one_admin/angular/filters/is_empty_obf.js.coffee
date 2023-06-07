AdminApp.filter 'isEmpty', [ ->
  (object) ->
    angular.equals({}, object) || angular.equals( [], object )
 ]
