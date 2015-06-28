angular.module('directives.materialize.tabs', [])
.directive 'materializeTabs', ($timeout) ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    $timeout () ->
      $(elem).tabs()


