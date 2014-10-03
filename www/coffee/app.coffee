angular.module("app", [
  "ionic"
  "app.controllers"
  "app.services"
  "app.directives"
  "ngFx"
]).run(($ionicPlatform) ->
  $ionicPlatform.ready ->
    cordova.plugins.Keyboard.hideKeyboardAccessoryBar true  if window.cordova and window.cordova.plugins.Keyboard
    StatusBar.styleDefault()  if window.StatusBar
    Parse.initialize("OueLHhADp4r43zJVjor1UlaKP8A672NTpnoD6JKQ", "HtxCby57dqU6pHSR2nCkjJZ3JflVg84m0ERXONQB")

).config ($stateProvider, $urlRouterProvider) ->
  $stateProvider.state("app",
    url: "/app"
    abstract: true
    templateUrl: "templates/menu.html"
    controller: "AppCtrl"
  ).state("app.search",
    url: "/home"
    views:
      menuContent:
        templateUrl: "templates/home.html"
  ).state("app.browse",
    url: "/browse"
    views:
      menuContent:
        controller: "CalculatorCtrl"
        templateUrl: "templates/browse.html"
  ).state("app.guides",
    url: "/guides"
    views:
      menuContent:
        templateUrl: "templates/guides.html"
        controller: "GuidesCtrl"
  ).state "app.single",
    url: "/guides/:guideId"
    views:
      menuContent:
        templateUrl: "templates/guide.html"
        controller: "GuideCtrl"

  $urlRouterProvider.otherwise "/app/guides"
