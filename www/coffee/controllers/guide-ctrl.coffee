angular.module("app.controllers")

.controller("GuideCtrl", ($scope, $stateParams, GuideContent, GuideStorage) ->
  GuideContent.getAll()
    .success((guides) ->
      $scope.guide = guides[$stateParams.guideId]
      $scope.guide.hasRead = true
      GuideStorage.setGuideStatus($stateParams.guideId, $scope.guide.hasRead)
    )
)
