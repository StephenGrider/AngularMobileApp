angular.module("app", ["ionic", "app.controllers", "app.services", "app.directives", "ngFx"]).run(function($ionicPlatform) {
  return $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if (window.StatusBar) {
      StatusBar.styleDefault();
    }
    return Parse.initialize("OueLHhADp4r43zJVjor1UlaKP8A672NTpnoD6JKQ", "HtxCby57dqU6pHSR2nCkjJZ3JflVg84m0ERXONQB");
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
        controller: "CalculatorCtrl",
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

angular.module("app.controllers", []).controller("AppCtrl", function($scope, $ionicModal, Referral) {
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
    Referral.save($scope.loginData);
    $scope.loginData = {};
    return $scope.closeLogin();
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
}).controller("CalculatorCtrl", function($scope, Financials) {
  var onFinancialsFinally, onFinancialsSuccess;
  $scope.monthlyPayment = 50;
  $scope.showZip = true;
  $scope.locationData = {};
  onFinancialsSuccess = (function(_this) {
    return function(resp) {
      console.log(resp);
      $scope.showZip = false;
      return $scope.data = resp;
    };
  })(this);
  onFinancialsFinally = (function(_this) {
    return function() {
      return $scope.spinner = false;
    };
  })(this);
  return $scope.submitZip = function() {
    $scope.spinner = true;
    return Financials.get({
      zip: $scope.locationData.zip
    }).success(onFinancialsSuccess)["finally"](onFinancialsFinally);
  };
});

angular.module("app.directives", []).directive('slideCalculator', function() {
  return {
    templateUrl: 'templates/directives/slide-calculator.html',
    restrict: 'E'
  };
}).directive('zipEntry', function() {
  return {
    templateUrl: 'templates/directives/zip-entry.html',
    restrict: 'E'
  };
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
}).service("Referral", function() {
  var ContactDetails;
  ContactDetails = Parse.Object.extend("Referral");
  return {
    save: function(details) {
      var contactDetails;
      contactDetails = new ContactDetails(details);
      return contactDetails.save();
    }
  };
}).service("Financials", function($http) {
  var performanceData, url;
  performanceData = null;
  url = window.nrel_address;
  return {
    get: function(options) {
      var params;
      params = {
        api_key: window.nrel_key,
        address: (options != null ? options.zip : void 0) || 93401,
        system_capacity: '5',
        module_type: 0,
        losses: 4,
        array_type: 1,
        tilt: 14,
        azimuth: 180
      };
      _.extend(params, options != null ? options.params : void 0);
      return $http.get(url, {
        params: params
      });
    }
  };
});
