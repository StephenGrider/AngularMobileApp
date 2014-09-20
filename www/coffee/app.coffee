angular.module("app", [
  "ionic"
  "app.controllers"
  "app.services"
]).run(($ionicPlatform) ->
  $ionicPlatform.ready ->
    cordova.plugins.Keyboard.hideKeyboardAccessoryBar true  if window.cordova and window.cordova.plugins.Keyboard
    StatusBar.styleDefault()  if window.StatusBar

).config ($stateProvider, $urlRouterProvider) ->
  $stateProvider.state("app",
    url: "/app"
    abstract: true
    templateUrl: "templates/menu.html"
    controller: "AppCtrl"
  ).state("app.search",
    url: "/search"
    views:
      menuContent:
        templateUrl: "templates/search.html"
  ).state("app.browse",
    url: "/browse"
    views:
      menuContent:
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


  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise "/app/guides"
