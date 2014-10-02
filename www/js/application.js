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



angular.module("app.directives", []).directive('slideCalculator', function(Financials) {
  return {
    templateUrl: 'templates/directives/slide-calculator.html',
    restrict: 'E',
    link: function($scope, ele, attrs) {
      return ele.find('input').bind('input', function(a) {
        return $scope.data = Financials.getProduction(a.target.value);
      });
    }
  };
}).directive('zipEntry', function() {
  return {
    templateUrl: 'templates/directives/zip-entry.html',
    restrict: 'E'
  };
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
});

angular.module("app.controllers").controller("CalculatorCtrl", function($scope, Financials, Geolocation, $q) {
  var onRequestsFail, onRequestsFinally, onRequestsSuccess;
  $scope.monthlyPayment = 250;
  $scope.showZip = true;
  $scope.locationData = {};
  onRequestsSuccess = function() {
    Financials.setMonthlyBill($scope.monthlyPayment);
    $scope.data = Financials.getProduction(250);
    $scope.city = Geolocation.getCity();
    $scope.state = Geolocation.getState();
    $scope.showZip = false;
    return $scope.ajaxError = false;
  };
  onRequestsFinally = function() {
    return $scope.spinner = false;
  };
  onRequestsFail = function() {
    return $scope.ajaxError = true;
  };
  $scope.submitZip = function() {
    $scope.spinner = true;
    return $q.all([
      Financials.get({
        zip: $scope.locationData.zip
      }), Geolocation.get({
        zip: $scope.locationData.zip
      })
    ]).then(onRequestsSuccess, onRequestsFail)["finally"](onRequestsFinally);
  };
  return $scope.showZip = function() {
    return $scope.showZip = true;
  };
});

angular.module("app.controllers").controller("GuideCtrl", function($scope, $stateParams, GuideContent, GuideStorage) {
  return GuideContent.getAll().success(function(guides) {
    $scope.guide = guides[$stateParams.guideId];
    $scope.guide.hasRead = true;
    return GuideStorage.setGuideStatus($stateParams.guideId, $scope.guide.hasRead);
  });
});

angular.module("app.controllers").controller("GuidesCtrl", function($scope, GuideContent, GuideStorage) {
  var onGetAll;
  onGetAll = function(guides) {
    return $scope.guides = GuideStorage.getGuideStatus(guides);
  };
  return GuideContent.getAll().success(onGetAll);
});

angular.module("app.services", []).service("Financials", function($http) {
  var performanceData, serviceObj, url;
  performanceData = null;
  url = window.nrel_address;
  return serviceObj = {
    systemLifeYears: 25,
    kwhCost: .17,
    get: function(options) {
      var params;
      params = {
        api_key: window.nrel_key,
        address: (options != null ? options.zip : void 0) || 93401,
        system_capacity: 1,
        module_type: 0,
        losses: 4,
        array_type: 1,
        tilt: 14,
        azimuth: 180
      };
      _.extend(params, options != null ? options.params : void 0);
      return $http.get(url, {
        params: params
      }).then(serviceObj._parseResponse);
    },
    setMonthlyBill: function(bill) {
      return serviceObj.monthlyBill = bill;
    },
    getProduction: function(bill) {
      serviceObj.setMonthlyBill(bill);
      if (!serviceObj.monthlyBill) {
        throw new Error('Monthly bill must be provided');
      }
      return {
        annualValue: serviceObj._getAnnualValue(),
        idealSystemSize: serviceObj._getIdealSystemSize(),
        lifeTimeValue: serviceObj._getLifeTimeValue(),
        monthlyProduction: serviceObj._getMonthlyProduction()
      };
    },
    _parseResponse: function(resp) {
      serviceObj.acAnnual = resp.data.outputs.ac_annual;
      return serviceObj.acMonthly = resp.data.outputs.ac_monthly;
    },
    _getMonthlyBill: function() {
      return serviceObj.monthlyBill;
    },
    _getIdealSystemSize: function() {
      return 12 * serviceObj._getMonthlyBill() / serviceObj.kwhCost / serviceObj.acAnnual;
    },
    _getAnnualValue: function() {
      return serviceObj.kwhCost * serviceObj.acAnnual * serviceObj._getIdealSystemSize();
    },
    _getLifeTimeValue: function() {
      return serviceObj._getAnnualValue() * serviceObj.systemLifeYears;
    },
    _getMonthlyProduction: function() {
      return serviceObj.acAnnual / 12 * serviceObj._getIdealSystemSize();
    }
  };
});

angular.module("app.services").service("Geolocation", function($http) {
  var service;
  return service = {
    get: function(options) {
      var params;
      params = {
        address: options.zip || 93401
      };
      return $http.get(window.gmap_address, {
        params: params
      }).then(service._parseResponse);
    },
    _parseResponse: function(resp) {
      var _ref, _ref1;
      service.city = (_ref = resp.data) != null ? _ref.results[0].address_components[1].short_name : void 0;
      return service.state = (_ref1 = resp.data) != null ? _ref1.results[0].address_components[2].long_name : void 0;
    },
    getCity: function() {
      return service.city;
    },
    getState: function() {
      return service.state;
    }
  };
});

angular.module("app.services").service("GuideContent", function($http) {
  return {
    getAll: function() {
      return $http.get('content/guide.json');
    }
  };
});

angular.module("app.services").service("GuideStorage", function(LocalStorage) {
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

angular.module("app.services").service("LocalStorage", function() {
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
});

angular.module("app.services").service("Referral", function() {
  var ContactDetails;
  ContactDetails = Parse.Object.extend("Referral");
  return {
    save: function(details) {
      var contactDetails;
      contactDetails = new ContactDetails(details);
      return contactDetails.save();
    }
  };
});
