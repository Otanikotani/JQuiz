angular.module('platform.app', [
    'templates-app',
    'templates-common',
    'ui.router',
    'domain',
    'services',
    'filters',
    'ngAnimate',
    'anim-in-out',
    'controllers'
])

    .config(function myAppConfig($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider) {
        $urlRouterProvider.otherwise('/dashboard');

        //var httpInterceptor = ['$rootScope', '$q', function (scope, $q) {
        //    function success(response) {
        //        return response;
        //    }
        //    function error(response) {
        //        var status = response.status;
        //        if (status == 401) {
        //            console.log('Changing state to login');
        //            $state.go('login');
        //            return;
        //        }
        //        return $q.reject(response);
        //    }
        //    return function (promise) {
        //        return promise.then(success, error);
        //    };
        //}];
        //$httpProvider.responseInterceptors.push(httpInterceptor);
        $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest';
        //check browser support
        //if (window.history && window.history.pushState) {
        //    //$locationProvider.html5Mode(true); will cause an error $location in HTML5 mode
        //    //requires a  tag to be present! Unless you set baseUrl tag after head tag like so: <head> <base href="/">
        //
        //    // to know more about setting base URL visit: https://docs.angularjs.org/error/$location/nobase
        //
        //    // if you don't wish to set base URL then use this
        //    $locationProvider.html5Mode({
        //        enabled: true,
        //        requireBase: false
        //    });
        //}

    })

    .run(function run() {
    })

    .controller('AppController', function AppController($scope, $rootScope, $state, $location, sessionService) {

        $rootScope.loadingScreen = 0;
        $rootScope.disableGlobalLoading = function () {
            if ($rootScope.loadingScreen !== 0) {
                $rootScope.loadingScreen--;
            }

        };
        $rootScope.enableGlobalLoading = function () {
            $rootScope.loadingScreen++;
        };
        $rootScope.$on('$stateChangeStart',
            function (event, toState, toParams, fromState, fromParams) {
                if (toState && toState.name != 'login') {
                    if (!sessionService.isLoggedIn()) {
                        event.preventDefault();
                        $state.go('login');
                    }
                }
            });
        $scope.$on('$stateChangeSuccess', function (event, toState, toParams, fromState, fromParams) {
            if (toState.name === 'login') {
                $scope.mainClass = 'stripes';
            } else {
                $scope.mainClass = '';
            }
            if (angular.isDefined(toState.data) && angular.isDefined(toState.data.pageTitle)) {
                $scope.pageTitle = toState.data.pageTitle;
            } else {
                $scope.pageTitle = 'Optimizer';
            }
        });

    });

angular.module('controllers', [
    'controllers.pages.login',
    'controllers.pages.navigation',
    'controllers.pages.settings',
    'controllers.pages.stats',
    'controllers.pages.dashboard',
    'controllers.pages.kpiTest'
]);

angular.module('domain', [
    'domain.users',
    'domain.kpis',
    'domain.charts'
]);
angular.module('services', [

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
