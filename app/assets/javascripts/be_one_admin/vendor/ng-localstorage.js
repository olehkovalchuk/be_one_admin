angular
.module( "ngLocalStorage", [] )
.factory( "$localStorage", [ "$window", "$q", function( $window, $q ) {
  function parse( value ){
    try{
      // this is in a try because if it is just a string JSON.parse will fail
      value = JSON.parse( value );
    }
    catch( e ){}
    return value;
  }
  return {
    // retrieves 1 or more keys based on a string, comma-delimited list or an array
    get: function( keys, defaultValue ){
      var deferred = $q.defer(),
        values;
      try{
        if( $window.localStorage.hasOwnProperty( keys ) ){
          values = parse( $window.localStorage[ keys ] );
        }
        else{
          // if keys is a comma delimited list, convert it to an array
          keys = typeof keys === "string" ? keys.split(",") : keys;
          values = {};
          angular.forEach( keys, function( key ){
            values[ key ] = parse( $window.localStorage[ key ] );
          } );
        }
        deferred.resolve( values );
      }
      catch( e ){
        deferred.reject( e );
      }
      return deferred.promise;
    },
    // creates / updates keys can be a single key / value or each property in an object will be set individually
    set: function( key, value ) {
      var deferred = $q.defer(),
        self = this,
        keys = [];
      try{
        if( typeof key === "string"){ // set a single value
          // set the value
          $window.localStorage[ key ] = typeof value !== "string" ? JSON.stringify( value ) : value;
          keys.push( key );
        }
        else if(key !== null && typeof key === "object" && !Array.isArray( key ) ){ // set multiple values from an object
          angular.forEach( key, function( val, key ){
            $window.localStorage[ key ] = typeof value !== "string" ? JSON.stringify( val ) : val;
            keys.push( key );
          } );
        }
        // read the write(s)
        self
          .get( keys )
          .then( function( result ){
            deferred.resolve( result );
          } );
      }
      catch( e ){
        // reject the promise on any error
        deferred.reject( e );
      }
      return deferred.promise;
    },
    // removes one or more keys based on an string, comma-delimited list, or an array
    remove: function( keys ) {
      var deferred = $q.defer();
      try{
        if( $window.localStorage.hasOwnProperty( keys ) ){ // remove just the single value
          $window.localStorage.removeItem( keys );
        }
        if( typeof keys === "string" || Array.isArray( keys ) ){ // keys is a comma-delimited list or an array
          // if keys is a comma delimited list, convert it to an array
          keys = typeof keys === "string" ? keys.split(",") : keys;
          angular.forEach( keys, function( key ){
            $window.localStorage.removeItem( key );
          } );
          deferred.resolve();
        }
        else if( keys !== null && typeof key === "object" ){ // keys is an object
          angular.forEach( keys, function( value, key ){
            $window.localStorage.removeItem( key );
          } );
          deferred.resolve();
        }
        else{
          deferred.reject( "Unsupported key type" );
        }
      }
      catch( e ){
        deferred.reject( e );
      }
      return deferred.promise;
    },
    // filters all items in localStorage by the key based on a string or regex
    filter: function( pattern ){
      var deferred = $q.defer(),
        self = this,
        result = {};
      // allow for a string or regex
      pattern = pattern instanceof RegExp ? pattern : new RegExp( pattern, "i" );
      try{
        self
          .all()
          .then( function( keys ){
            angular.forEach( keys, function( value, key ){
              if( pattern.test( key ) ){
                result[ key ] = value;
              }
            } );
            deferred.resolve( result );
          } );
      }
      catch( e ){
        deferred.reject( e );
      }
      return deferred.promise;
    },
    // takes a function to process each item against if true the item is kept
    map: function( func ){
      var deferred = $q.defer(),
        self = this,
        result = {};
      if( typeof func !== "function" ){
        deferred.reject( "Not a function" );
      }
      try{
        self
          .all()
          .then( function( keys ){
            angular.forEach( keys, function( value, key ){
              if( func( value, key ) ){
                result[ key ] = value;
              }
            } );
            deferred.resolve( result );
          } );
      }
      catch( e ){
        deferred.reject();
      }
      return deferred.promise;
    },
    // determines if a key exists or not
    exists: function( key ){
      var deferred = $q.defer();
      if( $window.localStorage.hasOwnProperty( key ) ){
        deferred.resolve( key );
      }
      else{
        deferred.reject( key );
      }
      return deferred.promise;
    },
    // gets all of the keys in localStorage and parses any JSON values
    all: function(){
      var deferred = $q.defer(),
        values = {};
      try{
        angular.forEach( $window.localStorage, function( value, key ){
          values[ key ] = parse( value );
        } );
        deferred.resolve( values );
      }
      catch( e ){
        deferred.reject( e );
      }

      return deferred.promise;
    }
  }
} ] );
