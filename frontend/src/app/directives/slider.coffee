angular.module('directives.slider', [])
.directive 'slider', ($timeout) ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    $timeout () ->
      thisSlider = $(elem).slider(
        full_width: true
        interval: 60000000
      )
      scope.$on 'FinishRenderEvent', (event) ->
        $(elem).find('.indicators').click () ->
          scope.$emit('IndicatorClickEvent',
            index: $(elem).find('.active').index()
          )
        event.stopPropagation()


