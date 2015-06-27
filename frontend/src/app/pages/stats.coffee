angular
.module('controllers.pages.stats', [
    'ui.router',
    'directives',
    'ngAnimate',
    'ngResource'
  ])

.config(
  ($stateProvider) ->
    $stateProvider
    .state('stats',
      url: '/stats'
      templateUrl: 'pages/stats.tpl.html'
      controller: 'StatsController'
      data:
        pageTitle: 'Stats')
)
.controller('StatsController', ['$scope', '$rootScope', '$state', 'KpiApi'
    ($scope, $rootScope, $state, KpiApi) ->
      for i in [0..100]
        KpiApi.Kpis.query(
          kpiTypeId: 29
          reportId: 2481
          selectionId: 5521
          columnId: 0
          accountId: 668
        , (result) ->
          console.log 'Result', result
        )
  ])
