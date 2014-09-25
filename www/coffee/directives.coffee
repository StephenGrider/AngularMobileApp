angular.module("app.directives", [])

.directive('slideCalculator', ->
  templateUrl: 'templates/directives/slide-calculator.html'
  restrict: 'E'
)

.directive('zipEntry', ->
  templateUrl: 'templates/directives/zip-entry.html'
  restrict: 'E'
)
