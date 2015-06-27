angular
.module('controllers.pages.kpiTest', [
    'ui.router',
    'directives',
    'ngAnimate',
    'ngResource'
  ])

.config(
  ($stateProvider) ->
    $stateProvider
    .state('kpi-test',
      url: '/kpi-test'
      templateUrl: 'pages/kpiTest.tpl.html'
      controller: 'KPITestController'
      data:
        pageTitle: 'KPITest')
)
.controller('KPITestController', ['$scope', '$rootScope', '$state', 'KpiApi'
    ($scope, $rootScope, $state, KpiApi) ->
      $scope.resolvedQueries = (false for i in [0..90])
      $scope.allResolved = 'Not resolved'

      stompClient = null
      $scope.checkSocket = ->
        connect = () ->
          socket = new SockJS('/Boost/requests')
          stompClient = Stomp.over(socket)
          stompClient.debug = null
          stompClient.connect {}, (frame) ->
            startMeasuring()

            stompClient.subscribe '/kpi/results', (kpivalue) ->
              index = JSON.parse(kpivalue.body).index
              $scope.resolvedQueries[index] = true
              $scope.$apply()
              console.log('Resolved', index, kpivalue)
            for i in [0..90]
              stompClient.send("/kpi/requests", {}, JSON.stringify({ 'index': i }))

        disconnect = () ->
          if stompClient != null
            stompClient.disconnect()
          console.log('Disconnected')

        connect()

      $scope.checkAjax = ->
        startMeasuring()
        for i in [0..90]
          cb = (index) ->
            return (data) ->
              console.log('Resolved query:', index)
              $scope.resolvedQueries[index] = data
          KpiApi.Kpis.query({}, cb(i), cb(i))

      startMeasuring = ->
        $scope.allResolved = 'Resolving'
        start = new Date().getTime()
        console.log('Start measuring', start)
        $scope.$watchCollection 'resolvedQueries', (newVal, oldVal) ->
          console.log('Changed!')
          resolved = true
          for i in $scope.resolvedQueries
            if !i
              resolved = false
              break
          if resolved
            end = new Date().getTime()
            console.log('End measuring', end)
            time = end - start
            $scope.allResolved = 'All resolved in ' + time/1000 + 's'
  ])
