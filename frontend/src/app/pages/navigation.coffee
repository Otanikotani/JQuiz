angular
.module('controllers.pages.navigation', [
    'ui.router',
    'directives',
    'ngAnimate',
    'ngResource'
  ])

.controller('navigation', ['$scope', '$rootScope', '$state', '$http', 'sessionService'
    ($scope, $rootScope, $state, $http, sessionService) ->
      $scope.authenticated = sessionService.isLoggedIn()
      $scope.$on 'LoggedInEvent', ()->
        $scope.authenticated = sessionService.isLoggedIn()
      $scope.$on 'LoggedOutEvent', ()->
        $scope.authenticated = sessionService.isLoggedIn()

      $scope.isOn = (state) ->
        $state.includes state

      $scope.goto = (newState) ->
        $state.go newState
      $scope.logout = ->
        $rootScope.disableGlobalLoading()
        sessionService.logout()
        $state.go 'login'
  ])

