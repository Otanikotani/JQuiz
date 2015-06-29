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


.controller('ResultsController', ['$scope', '$rootScope', '$state', '$firebaseObject', 'resultService'
    ($scope, $rootScope, $state, $firebaseObject, resultService) ->
      $scope.loading = false
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

  ])

