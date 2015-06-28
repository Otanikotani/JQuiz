angular.module('directives.onFinishRender', [])
.directive 'onFinishRender', ($timeout) ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    if (scope.$last == true)
      $timeout ->
        scope.$emit('FinishRenderEvent', {id: $(elem).parent().attr('id')})




