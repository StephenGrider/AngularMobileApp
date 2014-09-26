angular.module("app.directives", [])

.directive('slideCalculator', (Financials) ->
  templateUrl: 'templates/directives/slide-calculator.html'
  restrict: 'E'
  link: ($scope, ele, attrs) ->
    ele.find('input').bind('input', (a) ->
      $scope.data = Financials.getProduction(a.target.value)
      console.log $scope.data
    )
)

.directive('zipEntry', ->
  templateUrl: 'templates/directives/zip-entry.html'
  restrict: 'E'
)
