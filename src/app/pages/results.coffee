angular
.module('controllers.pages.results', [
    'ui.router',
    'directives',
    'ngAnimate',
    'firebase',
    'ngResource'
  ])

.config(
  ($stateProvider) ->
    $stateProvider
    .state 'results',
      url: '/results',
      templateUrl: 'pages/results.tpl.html'
      controller: 'ResultsController'
      data:
        pageTitle: 'JQuiz'
)

.factory('resultService', [() ->
    results = []
    addAll = (objs) ->
      results = objs
    clear = () ->
      results = []
    getAll = () ->
      results
    return {
      addAll: addAll
      clear: clear
      getAll: getAll
    }
  ])

.factory('loginService', [() ->
    service = {}
    service.status = 'OFFLINE'
    service.getStatus = ->
      service.status
    service.isLogged = ->
      service.status == 'LOGGED'
    service.getUser = ->
      service.user
    service.login = (cb) ->
      if service.status == 'OFFLINE'
        service.status = 'LOGGING'
        ref = new Firebase 'https://incandescent-fire-9197.firebaseio.com'
        ref.authWithOAuthPopup 'github', (error, authData) ->
          service.user = authData.github.cachedUserProfile.login
          service.status = 'LOGGED'
          cb?()
    return service
  ])


.controller('ResultsController', ['$scope', '$rootScope', '$state', '$firebaseObject', 'resultService', 'loginService'
    ($scope, $rootScope, $state, $firebaseObject, resultService, loginService) ->
      $scope.results = resultService.getAll()
      $scope.score = 0
      for result in $scope.results
        if result.answer.correct
          $scope.score += result.question.difficulty
      $scope.tryAgain = ->
        resultService.clear()
        $state.go 'quiz'

      $scope.isCorrect = (answer, givenAnswer)->
        answer.correct and (answer == givenAnswer)

      saveScore = () ->
        user = loginService.getUser()
        ref = new Firebase 'https://incandescent-fire-9197.firebaseio.com'
        $firebaseObject(ref.child('profiles').child(user)).$loaded (profile) ->
          console.log 'Profile', profile
          if profile.highest_score
            profile.highest_score = Math.max(profile.highest_score, $scope.score)
          else
            profile.highest_score = $scope.score
          if profile.attempts
            profile.attempts++
          else
            profile.attempts = 1
          profile.$save()

      if not loginService.isLogged()
        loginService.login(saveScore)
      else
        saveScore()
  ])

