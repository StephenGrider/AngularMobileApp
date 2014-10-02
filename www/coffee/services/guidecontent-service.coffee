angular.module("app.services")

.service("GuideContent", ($http) ->
  getAll: -> $http.get('content/guide.json')
)
