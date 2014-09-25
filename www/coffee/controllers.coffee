angular.module("app.controllers", [])

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

.controller("GuidesCtrl", ($scope, GuideContent, GuideStorage) ->
  onGetAll = (guides) ->
    $scope.guides = GuideStorage.getGuideStatus(guides)

  GuideContent.getAll()
    .success(onGetAll)
)

.controller("GuideCtrl", ($scope, $stateParams, GuideContent, GuideStorage) ->
  GuideContent.getAll()
    .success((guides) ->
      $scope.guide = guides[$stateParams.guideId]
      $scope.guide.hasRead = true
      GuideStorage.setGuideStatus($stateParams.guideId, $scope.guide.hasRead)
    )
)

.controller("CalculatorCtrl", ($scope, Financials) ->
  $scope.monthlyPayment = 50
  $scope.showZip = true
  $scope.locationData = {}

  onFinancialsSuccess = (resp) =>
    console.log resp
    $scope.showZip = false
    $scope.data = resp

  onFinancialsFinally = => $scope.spinner = false

  $scope.submitZip = ->
    $scope.spinner = true
    Financials.get(zip: $scope.locationData.zip)
      .success(onFinancialsSuccess)
      .finally(onFinancialsFinally)

)
