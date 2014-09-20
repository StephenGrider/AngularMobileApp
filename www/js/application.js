angular.module("starter", ["ionic", "starter.controllers", "starter.services"]).run(function($ionicPlatform) {
  return $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if (window.StatusBar) {
      return StatusBar.styleDefault();
    }
  });
}).config(function($stateProvider, $urlRouterProvider) {
  $stateProvider.state("app", {
    url: "/app",
    abstract: true,
    templateUrl: "templates/menu.html",
    controller: "AppCtrl"
  }).state("app.search", {
    url: "/search",
    views: {
      menuContent: {
        templateUrl: "templates/search.html"
      }
    }
  }).state("app.browse", {
    url: "/browse",
    views: {
      menuContent: {
        templateUrl: "templates/browse.html"
      }
    }
  }).state("app.playlists", {
    url: "/playlists",
    views: {
      menuContent: {
        templateUrl: "templates/playlists.html",
        controller: "PlaylistsCtrl"
      }
    }
  }).state("app.single", {
    url: "/playlists/:playlistId",
    views: {
      menuContent: {
        templateUrl: "templates/playlist.html",
        controller: "PlaylistCtrl"
      }
    }
  });
  return $urlRouterProvider.otherwise("/app/playlists");
});

angular.module("starter.controllers", []).controller("AppCtrl", function($scope, $ionicModal, $timeout) {
  $scope.loginData = {};
  $ionicModal.fromTemplateUrl("templates/login.html", {
    scope: $scope
  }).then(function(modal) {
    return $scope.modal = modal;
  });
  $scope.closeLogin = function() {
    return $scope.modal.hide();
  };
  $scope.login = function() {
    return $scope.modal.show();
  };
  return $scope.doLogin = function() {
    console.log("Doing login", $scope.loginData);
    return $timeout((function() {
      return $scope.closeLogin();
    }), 1000);
  };
}).controller("PlaylistsCtrl", function($scope, GuideContent) {
  var onGetAll;
  onGetAll = function(guides) {
    return $scope.playlists = guides;
  };
  return GuideContent.getAll().success(onGetAll);
}).controller("PlaylistCtrl", function($scope, $stateParams, GuideContent) {
  return GuideContent.getAll().success(function(guides) {
    return $scope.guide = guides[$stateParams.playlistId];
  });
});

angular.module("starter.services", []).service("GuideContent", function($http) {
  return {
    getAll: function() {
      return $http.get('content/guide.json');
    }
  };
});
