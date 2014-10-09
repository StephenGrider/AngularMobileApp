angular.module("app.controllers")

.controller("StudyCtrl", ($scope, $stateParams, StudyContent) ->
  StudyContent.getAll()
    .success((studies) ->
      $scope.study = studies[$stateParams.studyId]
    )
)
