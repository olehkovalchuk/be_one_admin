// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require angular
//= require turbolinks
//= require angular-animate
//= require angular-resource
//= require angular-route
//= require angular-ui-bootstrap-tpls
//= require angular-rails-templates
//= require angular-translate
//= require ng-table
//= require pace/pace
//= require_tree ./i18n
//= require ./vendor/plug
//= require ./theme/jquery.dataTables.min
//= require ./theme/dataTables.bootstrap.min
//= require ./vendor/bootstrap.min
//= require ./vendor/array-chunk
//= require ./vendor/angular-bootstrap-switch
//= require ./vendor/angular-ui-tree
//= require ./vendor/angular-context-menu
//= require ./vendor/angular-cookies
//= require ./vendor/ng-tags-input
//= require ./vendor/angular-inflector
//= require ./vendor/angular-duallist
//= require ./vendor/angular-datetimepicker
//= require ./vendor/angular-bootstrap-multiselect
//= require ./vendor/daterangepicker
//= require ./vendor/angular-daterangepicker
//= require ./vendor/angular-sanitize
//= require ./vendor/summernote
//= require ./vendor/tree-grid-directive
//= require ./vendor/ng-map.min
//= require ./vendor/angular-input-masks-standalone
//= require ./vendor/angular-ui-mask
//= require ./vendor/angular-file-upload.min
//= require ./vendor/underscore-min
//= require ./vendor/angular-underscore.min
//= require ./vendor/ng-localstorage
//= require ./vendor/select
////= require ./vendor/ol
////= require ./vendor/geocoder
//= require ./lib/moment
//= require ./lib/slimscroll
//= require ./angular/app
//= require_tree ./angular/templates
//= require_tree ./angular/factories
//= require_tree ./angular/filters
//= require_tree ./angular/directives
//= require_tree ./angular/configs
//= require_tree ./angular/controllers
//= require_tree ./theme

//= require admin_application


$(document).on('turbolinks:load', function () {
  App.init();
});
Date.prototype.yyyymmdd = function() {
    var yyyy = this.getFullYear().toString();
    var mm = (this.getMonth()+1).toString(); // getMonth() is zero-based
    var dd  = this.getDate().toString();
    return yyyy + "-" + (mm[1]?mm:"0"+mm[0]) + "-" + (dd[1]?dd:"0"+dd[0]); // padding
};
String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
};

window.removeFalsy = function(obj) {
  var newObj;
  newObj = {};
  Object.keys(obj).forEach(function(prop) {
    if (obj[prop]) {
      newObj[prop] = obj[prop];
    }
  });
  return newObj;
};

window.serialize = function(obj) {
  var str = [];
  for (var p in obj)
    if (obj.hasOwnProperty(p)) {
      str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
    }
  return str.join("&");
}
Array.prototype.clean = function(deleteValue) {
  for (var i = 0; i < this.length; i++) {
    if (this[i] == deleteValue) {
      this.splice(i, 1);
      i--;
    }
  }
  return this;
};
