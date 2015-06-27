angular
.module('domain.kpis', [
    'ngResource'
  ])

.factory('KpiApi', ['$resource',
    ($resource) ->
      Kpis: $resource('api/kpis/', {}, {
        query: {method: 'GET', isArray: true}
      })
  ])
