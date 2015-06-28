angular
.module('controllers.pages.quiz', [
    'ui.router',
    'directives',
    'ngAnimate',
    'firebase',
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

.controller('QuizController', ['$scope', '$rootScope', '$state', '$firebaseObject',
    ($scope, $rootScope, $state, $firebaseObject) ->
      ref = new Firebase 'https://incandescent-fire-9197.firebaseio.com'
      QUESTIONS_TO_ASK_TOTAL = 10
      questions = {}
      questionsOrder = []
      $scope.currentQuestionIndex = 0
      $scope.currentAnswer = {}
      $scope.answers = []

      getRandomInt = (min, max) ->
        Math.floor(Math.random() * (max - min + 1)) + min
      addIndex = (arr, max) ->
        newElement = getRandomInt(0, max)
        if newElement not in arr
          arr.push newElement
        else
          addIndex(arr, max)

      loadQuestion = (index) ->
        questions[index] = $firebaseObject ref.child('questions').child(questionsOrder[index])
      $firebaseObject(ref.child('stats').child('questions_count')).$loaded (data) ->
        qCount = data.$value
        for i in [0..QUESTIONS_TO_ASK_TOTAL - 1]
          addIndex(questionsOrder, qCount - 1)
        $scope.currentQuestionIndex = questionsOrder[0]
        loadQuestion $scope.currentQuestionIndex

        #load first question, then load others
        $scope.currentQuestion = questions[$scope.currentQuestionIndex]
        $scope.currentQuestion.$loaded () ->
          for i in questionsOrder[1..QUESTIONS_TO_ASK_TOTAL]
            loadQuestion(i)
      $scope.answer = () ->
        $scope.answers[questionsOrder[$scope.currentQuestionIndex]] = $scope.currentAnswer
        $scope.currentQuestion = questions[questionsOrder[$scope.currentQuestionIndex++]]

  ])

