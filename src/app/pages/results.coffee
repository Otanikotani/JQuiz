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

.controller('ResultsController', ['$scope', '$rootScope', '$state', '$firebaseObject',
    ($scope, $rootScope, $state, $firebaseObject) ->
      $scope.loading = false
      console.log 'Show results!'

      $scope.tryAgain = ->
        $state.go 'quiz'

  ])

