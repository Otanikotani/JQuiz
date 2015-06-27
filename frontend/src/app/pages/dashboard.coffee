angular
.module('controllers.pages.dashboard', [
    'ui.router',
    'directives',
    'ngAnimate',
    'ngResource',
    'controllers.pages.login'
  ])

.config(
  ($stateProvider) ->
    $stateProvider
    .state 'dashboard',
      url: '/dashboard',
      templateUrl: 'pages/dashboard.tpl.html'
      controller: 'DashboardController'
      data:
        pageTitle: 'Charts'
      resolve:
        ChartApi: 'ChartApi'
        $rootScope: '$rootScope'
        sessionService: 'sessionService'
        chartHeaders: (ChartApi, sessionService, $rootScope)->
          userId = sessionService.getUserId()
          ChartApi.Headers.query({accountId: userId}, (headers) ->
            headers
          ).$promise
)

.factory('chartService', ['ChartApi', (ChartApi) ->
    service = {}
    ChartApi.Templates.get((templates)->
      service.baseTemplate = templates.base
      service.lineTemplate = templates.line
      service.categoryTemplate = templates.category
      service.chartTemplates = {}
      for template in templates.charts
        service.chartTemplates[template.type] = _.assign(_.clone(service.baseTemplate, true), template)
    )

    service.applyBase = (chart) ->
      type = chart.type
      baseChartTemplate = _.clone service.chartTemplates[type], true
      chart.chart = _.merge baseChartTemplate, chart.chart
      if type == 'mscolumn2d'
        for categories in chart.categories
          _.merge categories, service.categoryTemplate
      else if type == 'scatter'
        for trendline in chart.trendlines
          for line in trendline.line
            _.merge line, service.lineTemplate
        for trendline in chart.vtrendlines
          for line in trendline.line
            _.merge line, service.lineTemplate
      return chart
    return service
])

.controller('DashboardController', ['$scope', '$rootScope', '$state', 'ChartApi',
                                    'sessionService', 'chartService', 'chartHeaders'
    ($scope, $rootScope, $state, ChartApi, sessionService, chartService, chartHeaders) ->
      $scope.noCharts = chartHeaders.length == 0
      if chartHeaders.length
        userId = sessionService.getUserId()
        $scope.hideIndicators = 'hide-indicators'
        $scope.selectedIndex = 0
        $scope.chartIndexes = (i for i in [0..chartHeaders.length - 1])
        $scope.chartLoadingStatuses = (false for i in [0..chartHeaders.length - 1])

        loadChart = (index, cb) ->
          $scope.chartLoadingStatuses[index] = true
          ChartApi.Charts.get({accountId: userId, index: index}, (chart) ->
            chartType = chart.type
            result = chartService.applyBase(chart)
            graph = new FusionCharts(
              id: 'chart' + index
              type: chartType
              renderAt: 'chartContainer' + index
              width: '100%'
              height: '100%'
              dataFormat: 'json'
              dataSource: result
            )
            $scope.chartLoadingStatuses[index] = false
            cb?()
            graph.render()
          )
        loadCharts = () ->
          if $scope.chartIndexes.length > 0
            loadChart 0, ()->
              if $scope.chartIndexes.length > 1
                $scope.hideIndicators = ''
                for index in [1..$scope.chartIndexes.length - 1]
                  loadChart index
        if $scope.chartIndexes.length > 0
          $scope.noCharts = false
          loadCharts()
        else
          $scope.noCharts = true

        $scope.$on 'IndicatorClickEvent', (event, data) ->
          $scope.selectedIndex = data.index
          $scope.$apply()
  ])

