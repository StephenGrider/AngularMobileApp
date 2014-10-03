angular.module("app.controllers")

.controller("AppCtrl", ($scope, $ionicModal, Referral) ->
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
    Referral.save($scope.loginData)
    $scope.loginData = {}
    $scope.closeLogin()
)
