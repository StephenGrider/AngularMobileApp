angular.module("app.services")

.factory("GuideContent", ($http) ->
  getAll: -> $http.get('content/guide.json')
)
