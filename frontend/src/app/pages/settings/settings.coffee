angular
.module('controllers.pages.settings', [
    'ui.router',
    'directives',
    'ngAnimate',
    'ngResource'
  ])

.config(
  ($stateProvider) ->
    $stateProvider
    .state('settings',
      url: '/settings'
      abstract: true,
      templateUrl: 'pages/settings/settings.tpl.html'
      controller: 'SettingsController'
      data:
        pageTitle: 'Settings')
      .state('settings.optionBundles',
        url: '/option-bundles'
        templateUrl: 'pages/settings/optionBundles.tpl.html'
        controller: 'OptionBundlesController'
      )
      .state('settings.userContent',
        url: '/userContent'
        templateUrl: 'pages/settings/userContent.tpl.html'
        controller: 'UserContentController'
      )
      .state('settings.bestPractices',
        url: '/best-practices'
        templateUrl: 'pages/settings/bestPractices.tpl.html'
        controller: 'BestPracticesController'
      )
      .state('settings.preferences',
        url: ''
        templateUrl: 'pages/settings/preferences.tpl.html'
        controller: 'PreferencesController'
        resolve:
          UserApi: 'UserApi'
          sessionService: 'sessionService'
          preferences: (UserApi, sessionService)->
            userId = sessionService.getUserId()
            UserApi.Preferences.get({accountId: userId}).$promise

    )
)
.controller('SettingsController', ['$scope', '$rootScope', '$state', 'sessionService'
    ($scope, $rootScope, $state, sessionService) ->
      $scope.goto = (substate) ->
        newState = 'settings.' + substate
        $state.go newState
      $scope.isOn = (state) ->
        active =  $state.current.name.split('.')[1]
        active == state
  ])
.controller('PreferencesController', ['$scope', 'UserApi', 'sessionService', 'preferences'
    ($scope, UserApi, sessionService, preferences) ->
      console.log 'preferences', preferences
      $scope.preferences = preferences

      $scope.submit = ->
        save = $scope.preferences
        save.accountId = sessionService.getUserId()
        UserApi.Preferences.update(save, (updated) ->
          $scope.preferences = updated
        )
])
.controller('OptionBundlesController', ['$scope', '$rootScope', 'sessionService'
    ($scope, $rootScope, sessionService) ->
])
.controller('UserContentController', ['$scope', '$rootScope', 'sessionService'
    ($scope, $rootScope, sessionService) ->
])
.controller('BestPracticesController', ['$scope', '$rootScope', 'sessionService'
    ($scope, $rootScope, sessionService) ->
])

