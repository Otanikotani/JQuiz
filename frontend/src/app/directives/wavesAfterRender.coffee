angular.module('directives.wavesAfterRender', [])
  .directive 'wavesAfterRender', () ->
    restrict: 'A',
    link: (scope, element, attrs) ->
      window.Waves.displayEffect() if scope.$last == true
