angular
.module('controllers.pages.login', [
    'ui.router',
    'directives',
    'ngAnimate',
    'ngResource'
  ])

.config(
  ($stateProvider) ->
    $stateProvider
    .state 'login',
      url: '/login',
      templateUrl: 'pages/login.tpl.html'
      controller: 'LoginController'
      data:
        pageTitle: 'Optimizer'
)

.factory('sessionService', ['$http', '$rootScope', ($http, $rootScope) ->
    session = {}
    session.login = (credentials, cb, ercb) ->
      $rootScope.enableGlobalLoading()
      $http.post("login", "username=" + credentials.username + "&password=" + credentials.password, {
        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
      }).then( (data) ->
        $rootScope.disableGlobalLoading()
        $rootScope.loadingScreen = false
        sessionStorage.setItem "userId", data.data.userId
        sessionStorage.setItem "username", data.data.username
        sessionStorage.setItem "authenticated", {}
        cb?()
      , (data) ->
        $rootScope.disableGlobalLoading()
        $rootScope.loadingScreen = false
        console.log "error logging in"
        ercb?()
      )
    session.getUserId = ->
      sessionStorage.getItem("userId")

    session.logout = ->
      session.loggedIn = false
      sessionStorage.removeItem "userId"
      sessionStorage.removeItem "username"
      sessionStorage.removeItem "authenticated"
      $rootScope.$broadcast 'LoggedOutEvent', {}
    session.isLoggedIn = -> sessionStorage.getItem("authenticated")
    return session
])

.controller('LoginController', ['$scope', '$rootScope', '$state', '$http', 'sessionService', '$stateParams', 'UserApi'
    ($scope, $rootScope, $state, $http, sessionService, $stateParams, UserApi) ->
      if sessionService.isLoggedIn()
        $state.go('dashboard')
      $scope.credentials =
        username: ''
        password: ''

      $scope.emptyLoginValidationFailed = false
      $scope.emptyPasswordValidationFailed = false
      $scope.validationMessage = ''

      $scope.login = () ->
        $scope.emptyLoginValidationFailed = $scope.credentials.username == ''
        $scope.emptyPasswordValidationFailed = $scope.credentials.password == ''

        if $scope.credentials.username != '' and $scope.credentials.password != ''
          $scope.validationMessage = ''
          onSuccess = ->
            $rootScope.$broadcast('LoggedInEvent', {})
            $state.go('dashboard')
          onFailure = ->
            $scope.validationMessage = 'Login failed, please check your credentials'
            showStaggeredList('#error-message')
            $scope.emptyLoginValidationFailed = true
            $scope.emptyPasswordValidationFailed = true
          sessionService.login($scope.credentials, onSuccess, onFailure)
        else
          $scope.validationMessage = 'Please enter your credentials'
          showStaggeredList('#error-message')
  ])

