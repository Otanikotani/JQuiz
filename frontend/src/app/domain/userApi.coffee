angular
.module('domain.users', [
    'ngResource'
  ])

.factory('UserApi', ['$resource',
    ($resource) ->
      Accounts: $resource('api/accounts/:id', {}, {
        query: {method: 'GET', params: {id: ''}, isArray: true}
      })
      Preferences: $resource('api/accounts/:accountId/preferences', {}, {
        update: {method:'PUT', params: {accountId: '@accountId'}}
      })
  ])
