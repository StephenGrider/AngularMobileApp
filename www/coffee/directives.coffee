angular.module("app.directives", [])

.directive('slideCalculator', (Financials) ->
  templateUrl: 'templates/directives/slide-calculator.html'
  restrict: 'E'
  link: ($scope, ele, attrs) ->
    ele.find('input').bind('input', (e) ->
      $scope.data = Financials.getProduction(e.target.value)
    )
)

.directive('zipEntry', ->
  templateUrl: 'templates/directives/zip-entry.html'
  restrict: 'E'
)
