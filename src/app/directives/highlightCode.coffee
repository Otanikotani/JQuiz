angular.module('directives.highlightCode', [])
.directive 'highlightCode', () ->
  restrict: 'A',
  link: (scope, element, attrs) ->
    scope.$watch('currentQuestion', () ->
      $(element).find('pre code').each (i, block) ->
        hljs.highlightBlock(block)
    )
