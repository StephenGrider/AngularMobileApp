angular.module("starter.controllers", []).controller("AppCtrl", ($scope, $ionicModal, $timeout) ->
  $scope.loginData = {}
  $ionicModal.fromTemplateUrl("templates/login.html",
    scope: $scope
  ).then (modal) ->
    $scope.modal = modal

  $scope.closeLogin = ->
    $scope.modal.hide()

  $scope.login = ->
    $scope.modal.show()

  $scope.doLogin = ->
    console.log "Doing login", $scope.loginData
    $timeout (->
      $scope.closeLogin()
    ), 1000

).controller("GuidesCtrl", ($scope, GuideContent, GuideStorage) ->
  onGetAll = (guides) ->
    $scope.guides = GuideStorage.getGuideStatus(guides)

  GuideContent.getAll()
    .success(onGetAll)

).controller "GuideCtrl", ($scope, $stateParams, GuideContent, GuideStorage) ->
  GuideContent.getAll()
    .success((guides) ->
      $scope.guide = guides[$stateParams.guideId]
      $scope.guide.hasRead = true
      GuideStorage.setGuideStatus($stateParams.guideId, $scope.guide.hasRead)
    )
