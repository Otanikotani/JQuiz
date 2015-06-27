angular.module('directives.autoFocus', [])
.directive 'autoFocus', ($timeout) ->
  restrict: 'A'
  link: (scope, elem) ->
    $timeout () ->
      elem[0].focus()
