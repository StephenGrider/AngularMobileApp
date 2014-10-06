angular.module("app.controllers")

.controller("CalculatorCtrl", ($scope, Financials, Geolocation, $q) ->
  $scope.monthlyPayment = 250
  $scope.showZip = true
  $scope.locationData = {}

  onRequestsSuccess = ->
    Financials.setMonthlyBill($scope.monthlyPayment)
    $scope.data = Financials.getProduction(250)
    $scope.city = Geolocation.getCity()
    $scope.state = Geolocation.getState()
    $scope.showZip = false
    $scope.ajaxError = false

  onRequestsFinally = ->
    $scope.spinner = false

  onRequestsFail = -> $scope.ajaxError = true

  $scope.submitZip = ->
    $scope.spinner = true
    $q.all([
      Financials.get(zip: $scope.locationData.zip),
      Geolocation.get(zip: $scope.locationData.zip)
    ])
      .then(onRequestsSuccess, onRequestsFail)
      .finally(onRequestsFinally)

  $scope.reset = ->
    $scope.showZip = true
)
