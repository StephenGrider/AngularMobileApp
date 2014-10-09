angular.module("app.controllers")

.controller("StudiesCtrl", ($scope, StudyContent) ->
  onGetAll = (studies) ->
    $scope.studies = studies

  StudyContent.getAll()
    .success(onGetAll)
)
