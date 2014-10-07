angular.module("app.controllers")

.controller("StudyCtrl", ($scope, $stateParams, GuideContent, GuideStorage) ->
  GuideContent.getAll()
    .success((guides) ->
      $scope.guide = guides[$stateParams.studyId]
    )
)
