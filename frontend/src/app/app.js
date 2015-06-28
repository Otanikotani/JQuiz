angular.module('platform.app', [
    'templates-app',
    'templates-common',
    'ui.router',
    'filters',
    'ngAnimate',
    'anim-in-out',
    'controllers'
])

    .config(function myAppConfig($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider) {
        $urlRouterProvider.otherwise('/quiz');
    })

    .controller('AppController', function AppController($scope, $rootScope, $state, $location) {
        $scope.$on('$stateChangeSuccess', function (event, toState, toParams, fromState, fromParams) {
            if (angular.isDefined(toState.data) && angular.isDefined(toState.data.pageTitle)) {
                $scope.pageTitle = toState.data.pageTitle;
            } else {
                $scope.pageTitle = 'JQuiz';
            }
        });

    });

angular.module('controllers', [
    'controllers.pages.quiz'
]);
angular.module('filters', [
    'filters.fromNow'
]);
angular.module('directives', [
    'directives.wavesAfterRender',
    'directives.preLoader',
    'directives.staggeredList',
    'directives.onFinishRender',
    'directives.autoFocus',
    'directives.slider',
    'directives.materialize.tabs',
    'directives.fadingCaption'
]);
