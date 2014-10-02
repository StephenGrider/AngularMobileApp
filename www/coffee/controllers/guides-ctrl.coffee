angular.module("app.controllers")

.controller("GuidesCtrl", ($scope, GuideContent, GuideStorage) ->
  onGetAll = (guides) ->
    $scope.guides = GuideStorage.getGuideStatus(guides)

  GuideContent.getAll()
    .success(onGetAll)
)
