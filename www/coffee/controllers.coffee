
# Form data for the login modal

# Create the login modal that we will use later

# Triggered in the login modal to close it

# Open the login modal

# Perform the login action when the user submits the login form

# Simulate a login delay. Remove this and replace with your login
# code if using a login system
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

).controller("PlaylistsCtrl", ($scope, GuideContent ) ->
  onGetAll = (guides) ->


    $scope.playlists = guides




  GuideContent.getAll()
    .success(onGetAll)

).controller "PlaylistCtrl", ($scope, $stateParams, GuideContent) ->
  GuideContent.getAll()
    .success((guides) ->
      $scope.guide = guides[$stateParams.playlistId]
    )
