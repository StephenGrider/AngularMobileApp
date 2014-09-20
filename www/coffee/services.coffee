angular.module("starter.services", []).service("GuideContent", ($http) ->
  getAll: -> $http.get('content/guide.json')
)
