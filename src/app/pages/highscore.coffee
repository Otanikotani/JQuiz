angular
.module('controllers.pages.highscore', [
    'ui.router',
    'directives',
    'ngAnimate',
    'firebase',
    'controllers.pages.results',
    'ngResource'
  ])

.config(
  ($stateProvider) ->
    $stateProvider
    .state 'highscore',
      url: '/highscore',
      templateUrl: 'pages/highscore.tpl.html'
      controller: 'HighscoreController'
      data:
        pageTitle: 'JQuiz'
)

.controller('HighscoreController', ['$scope', '$rootScope', '$state', '$firebaseObject', 'loginService'
    ($scope, $rootScope, $state, $firebaseObject, loginService) ->
      $scope.profiles = []
      query = $rootScope.FIREBASE.child('profiles').orderByChild('highest_score').limitToLast(10)
      query.on 'child_added', (snapshot) ->
        profile =
          name: snapshot.key()
          value: snapshot.val()
          score: snapshot.val().highest_score
        $scope.profiles.push(profile)
        $scope.$apply()
  ])

