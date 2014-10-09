angular.module("app.services")

.factory("StudyContent", ($http) ->
  getAll: -> $http.get('content/study.json')
)
