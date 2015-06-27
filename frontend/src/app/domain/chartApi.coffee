angular
.module('domain.charts', [
    'ngResource'
  ])

.factory('ChartApi', ['$resource',
    ($resource) ->
      Charts: $resource('api/accounts/:accountId/chartResources/:index', {}, {
        query: {method: 'GET', params: {accountId: '', index: ''}, isArray: true}
      })
      Headers: $resource('api/accounts/:accountId/chartHeaders', {}, {
        query: {method: 'GET', params: {accountId: ''}, isArray: true}
      })
      Templates: $resource('assets/charts/templates.json')
  ])
