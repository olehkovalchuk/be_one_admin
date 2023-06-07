$(document).on('ready page:load', function(){
  Array.prototype.chunk = function(size){
    return _.chain(this).groupBy(function(element, index){
      return Math.floor(index/size);
    }).toArray().value();
  }
})
