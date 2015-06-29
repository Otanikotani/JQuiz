angular
.module('controllers.pages.quiz', [
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
    .state 'quiz',
      url: '/quiz',
      templateUrl: 'pages/quiz.tpl.html'
      controller: 'QuizController'
      data:
        pageTitle: 'JQuiz'
)

.controller('QuizController', ['$scope', '$rootScope', '$state', '$firebaseObject', 'resultService'
    ($scope, $rootScope, $state, $firebaseObject, resultService) ->
      QUESTIONS_TO_ASK_TOTAL = 10
      questions = {}
      questionsStatuses = {}
      questionsOrder = []
      $scope.loading = true
      $scope.total = QUESTIONS_TO_ASK_TOTAL
      $scope.currentQuestionIndex = 0
      $scope.currentAnswer = undefined
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
        questions[qIndex] = $firebaseObject $rootScope.FIREBASE.child('questions').child(qIndex)
        questions[qIndex].$loaded ()->
          questionsStatuses[qIndex] = true

      $firebaseObject($rootScope.FIREBASE.child('stats').child('questions_count')).$loaded (data) ->
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

      saveAnswer = ->
        answer =
          question: $scope.currentQuestion
          answer: $scope.currentAnswer
        $scope.answers.push(answer)

      $scope.answer = () ->
        saveAnswer()
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
        $scope.currentAnswer = undefined

      $scope.done = ->
        saveAnswer()
        resultService.addAll($scope.answers)
        $state.go 'results'


      $scope.isDone = ->
        $scope.currentQuestionIndex + 1 >= $scope.total
  ])

