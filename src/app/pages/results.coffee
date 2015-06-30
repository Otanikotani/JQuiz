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

.factory('resultService', ['$rootScope', ($rootScope) ->
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

.factory('loginService', ['$rootScope', ($rootScope) ->
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
        $rootScope.FIREBASE.authWithOAuthPopup 'github', (error, authData) ->
          console.log(authData.github)
          service.user = authData.github.cachedUserProfile
          service.status = 'LOGGED'
          cb?()
    return service
  ])


.controller('ResultsController', ['$scope', '$rootScope', '$state', '$firebaseObject', 'resultService', 'loginService'
    ($scope, $rootScope, $state, $firebaseObject, resultService, loginService) ->
      $scope.results = resultService.getAll()
      $scope.score = 0

      $scope.isCorrect = (answer, givenAnswer) ->
        answer.correct and (answer == givenAnswer)

      $scope.isMultipleCorrect = (answer, givenAnswers) ->
        (answer.correct and (answer in givenAnswers)) or (!answer.correct and (answer not in givenAnswers))

      for result in $scope.results
        if not result.question.multiple
          if result.answer.correct
            $scope.score += result.question.difficulty
        else
          totalAnswers = result.question.answers.length
          part = 1 / totalAnswers
          for answer in result.question.answers
            if $scope.isMultipleCorrect(answer, result.answer)
              $scope.score += result.question.difficulty * part

      $scope.tryAgain = ->
        resultService.clear()
        $state.go 'quiz'

      saveScore = () ->
        user = loginService.getUser()
        $firebaseObject($rootScope.FIREBASE.child('profiles').child(user.login)).$loaded (profile) ->
          if profile.highest_score
            profile.highest_score = Math.max(profile.highest_score, $scope.score)
          else
            profile.highest_score = $scope.score
          if profile.attempts
            profile.attempts++
          else
            profile.attempts = 1
          profile.avatar = user.avatar_url
          profile.$save()

      if not loginService.isLogged()
        loginService.login(saveScore)
      else
        saveScore()
  ])

