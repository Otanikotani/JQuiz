angular.module('filters.sanitize', [])
.filter('sanitize', ['$sce', ($sce) ->
  (htmlCode) ->
    $sce.trustAsHtml(htmlCode)
])
