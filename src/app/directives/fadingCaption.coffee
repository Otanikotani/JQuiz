angular.module('directives.fadingCaption', [])
.directive 'fadingCaption', () ->
  restrict: 'A'
  scope:
    show: '='
  link: (scope, elem, attrs) ->
    velocityArgs =
      opacity: if scope.show then 1 else 0
      translateX: 0
      translateY: 0
    durationArgs =
      duration: 1000
      delay: 0
      queue: false
      easing: 'easeOutQuad'
    $(elem).velocity(velocityArgs, durationArgs)

