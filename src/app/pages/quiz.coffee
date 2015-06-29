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
      questionsStatuses = {}
      questionsOrder = []
      $scope.loading = true
      $scope.total = QUESTIONS_TO_ASK_TOTAL
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
        qIndex = index
        questionsStatuses[qIndex] = false
        questions[qIndex] = $firebaseObject ref.child('questions').child(qIndex)
        questions[qIndex].$loaded ()->
          questionsStatuses[qIndex] = true

      $firebaseObject(ref.child('stats').child('questions_count')).$loaded (data) ->
        qCount = data.$value
        for i in [0..QUESTIONS_TO_ASK_TOTAL - 1]
          addIndex(questionsOrder, qCount - 1)

        #load first question, then load others
        loadQuestion questionsOrder[$scope.currentQuestionIndex]
        $scope.currentQuestion = questions[questionsOrder[$scope.currentQuestionIndex]]
        $scope.currentQuestion.$loaded () ->
          $scope.loading = false
          for i in questionsOrder[1..QUESTIONS_TO_ASK_TOTAL]
            loadQuestion(i)

      $scope.submit = () ->
        if $scope.isDone() then $scope.done() else $scope.answer()

      $scope.answer = () ->
        $scope.answers[questionsOrder[$scope.currentQuestionIndex]] = $scope.currentAnswer
        qIndex = questionsOrder[++$scope.currentQuestionIndex]
        nextQuestion = questions[qIndex]
        status = questionsStatuses[qIndex]
        if !status
          $scope.loading = true
          nextQuestion.$loaded () ->
            $scope.loading = false
            $scope.currentQuestion = nextQuestion
        else
          $scope.currentQuestion = nextQuestion

      $scope.done = ->
        console.log $scope.answers

      $scope.isDone = ->
        $scope.currentQuestionIndex + 1 >= $scope.total

  ])

