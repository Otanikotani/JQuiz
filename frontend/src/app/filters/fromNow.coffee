angular.module('filters.fromNow', [])
.filter('fromNow', () ->
  (dateString) ->
    moment(dateString).fromNow()
)
