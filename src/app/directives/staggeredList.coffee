angular.module('directives.staggeredList', [])
.directive 'staggeredList', ($timeout) ->
  restrict: 'A'
  link: (scope, elem, attrs) ->
    scope.$on('FinishRenderEvent', (event, data) ->
      if data.id ==  attrs.id
        time = 0
        listElems = $(elem).find('a, li')

        listElems.velocity(
          {translateX: "-100px"},
          {duration: 0}
        )
        listElems.each( () ->
          velocityArg =
            opacity: "1"
            translateX: "0"
          durationArg =
            duration: 800
            delay: time
            easing: [60, 10]
          $(this).velocity(velocityArg, durationArg)
          time += 120
        )
        event.stopPropagation()
    )




