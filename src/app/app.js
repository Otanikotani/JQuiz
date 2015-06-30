angular.module('platform.app', [
    'templates-app',
    'templates-common',
    'ui.router',
    'filters',
    'ngAnimate',
    'anim-in-out',
    'firebase',
    'controllers'
])

    .config(function myAppConfig($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider) {
        $urlRouterProvider.otherwise('/quiz');
    })

    .run(function () {
        hljs.configure({useBR: true});
    })

    .controller('AppController', function AppController($scope, $rootScope, $state, $location) {
        $rootScope.FIREBASE = new Firebase('https://incandescent-fire-9197.firebaseio.com');
        $scope.$on('$stateChangeSuccess', function (event, toState, toParams, fromState, fromParams) {
            if (angular.isDefined(toState.data) && angular.isDefined(toState.data.pageTitle)) {
                $scope.pageTitle = toState.data.pageTitle;
            } else {
                $scope.pageTitle = 'JQuiz';
            }
        });

    });

angular.module('controllers', [
    'controllers.pages.quiz',
    'controllers.pages.results',
    'controllers.pages.highscore'
]);
angular.module('filters', [
    'filters.fromNow',
    'filters.sanitize'
]);
angular.module('directives', [
    'directives.wavesAfterRender',
    'directives.preLoader',
    'directives.staggeredList',
    'directives.onFinishRender',
    'directives.autoFocus',
    'directives.slider',
    'directives.materialize.tabs',
    'directives.fadingCaption',
    'directives.highlightCode'
]);
