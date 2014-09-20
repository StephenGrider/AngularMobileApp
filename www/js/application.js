angular.module("app", ["ionic", "app.controllers", "app.services"]).run(function($ionicPlatform) {
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
  }).state("app.guides", {
    url: "/guides",
    views: {
      menuContent: {
        templateUrl: "templates/guides.html",
        controller: "GuidesCtrl"
      }
    }
  }).state("app.single", {
    url: "/guides/:guideId",
    views: {
      menuContent: {
        templateUrl: "templates/guide.html",
        controller: "GuideCtrl"
      }
    }
  });
  return $urlRouterProvider.otherwise("/app/guides");
});

angular.module("app.controllers", []).controller("AppCtrl", function($scope, $ionicModal, $timeout) {
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
}).controller("GuidesCtrl", function($scope, GuideContent, GuideStorage) {
  var onGetAll;
  onGetAll = function(guides) {
    return $scope.guides = GuideStorage.getGuideStatus(guides);
  };
  return GuideContent.getAll().success(onGetAll);
}).controller("GuideCtrl", function($scope, $stateParams, GuideContent, GuideStorage) {
  return GuideContent.getAll().success(function(guides) {
    $scope.guide = guides[$stateParams.guideId];
    $scope.guide.hasRead = true;
    return GuideStorage.setGuideStatus($stateParams.guideId, $scope.guide.hasRead);
  });
});

angular.module("app.services", []).service("LocalStorage", function() {
  var prefix;
  prefix = "_solar";
  return {
    get: function(key) {
      return JSON.parse(localStorage.getItem("" + prefix + ":" + key));
    },
    set: function(key, item) {
      return localStorage.setItem("" + prefix + ":" + key, JSON.stringify(item));
    },
    setPrefix: function(string) {
      return prefix = string;
    }
  };
}).service("GuideContent", function($http) {
  return {
    getAll: function() {
      return $http.get('content/guide.json');
    }
  };
}).service("GuideStorage", function(LocalStorage) {
  return {
    getGuideStatus: function(guides) {
      var storage;
      storage = LocalStorage.get("guide");
      if (storage === null) {
        LocalStorage.set("guide", {});
        storage = {};
      }
      return _(guides).each(function(guide) {
        return guide.hasRead = storage[guide.id] || false;
      });
    },
    setGuideStatus: function(id, hasRead) {
      var storage;
      storage = LocalStorage.get("guide");
      storage[id] = hasRead;
      return LocalStorage.set("guide", storage);
    }
  };
});
