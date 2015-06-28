angular
.module('controllers.pages.quiz', [
    'ui.router',
    'directives',
    'ngAnimate',
    'ngResource'
  ])

.config(
  ($stateProvider) ->
    $stateProvider
    .state 'quiz',
      url: '/quiz',
      templateUrl: 'pages/quiz.tpl.html'
      controller: 'QuizController'
      data:
        pageTitle: 'JQuiz'
)

.controller('QuizController', ['$scope', '$rootScope', '$state',
    ($scope, $rootScope, $state) ->
      $scope.test = 'hello, world!!!!'
  ])

