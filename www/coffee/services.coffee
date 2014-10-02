angular.module("app.services", [])

.service("LocalStorage", ->
  prefix = "_solar"

  get: (key) ->
    JSON.parse(localStorage.getItem("#{prefix}:#{key}"))
  set: (key, item) ->
    localStorage.setItem("#{prefix}:#{key}", JSON.stringify(item))
  setPrefix: (string) ->
    prefix = string
)

.service("GuideContent", ($http) ->
  getAll: -> $http.get('content/guide.json')
)

.service("GuideStorage", (LocalStorage) ->
  getGuideStatus: (guides) ->
    storage = LocalStorage.get("guide")

    if storage is null
      LocalStorage.set("guide", {})
      storage = {}

    _(guides).each (guide) ->
      guide.hasRead = storage[guide.id] || false

  setGuideStatus: (id, hasRead) ->
    storage = LocalStorage.get("guide")
    storage[id] = hasRead
    LocalStorage.set("guide", storage)
)

.service("Referral", ->
  ContactDetails = Parse.Object.extend("Referral");

  save: (details) ->
    contactDetails = new ContactDetails(details)
    contactDetails.save()
)

.service("Financials", ($http) ->
  performanceData = null
  url = window.nrel_address

  serviceObj =
    systemLifeYears: 25
    kwhCost: .17
    get: (options) ->
      params =
        api_key: window.nrel_key
        address: options?.zip || 93401
        system_capacity: 1
        module_type: 0
        losses: 4
        array_type: 1
        tilt: 14
        azimuth: 180

      _.extend(params, options?.params)

      $http.get(url, params: params)
        .then(serviceObj._parseResponse)

    setMonthlyBill: (bill) ->
      serviceObj.monthlyBill = bill

    getProduction: (bill) ->
      serviceObj.setMonthlyBill(bill)

      throw new Error('Monthly bill must be provided') unless serviceObj.monthlyBill

      annualValue: serviceObj._getAnnualValue()
      idealSystemSize: serviceObj._getIdealSystemSize()
      lifeTimeValue: serviceObj._getLifeTimeValue()
      monthlyProduction: serviceObj._getMonthlyProduction()

    _parseResponse: (resp) ->
      serviceObj.acAnnual = resp.data.outputs.ac_annual
      serviceObj.acMonthly = resp.data.outputs.ac_monthly

    _getMonthlyBill: ->
      serviceObj.monthlyBill

    _getIdealSystemSize: ->
      12 * serviceObj._getMonthlyBill() / serviceObj.kwhCost / serviceObj.acAnnual

    _getAnnualValue: ->
      serviceObj.kwhCost * serviceObj.acAnnual * serviceObj._getIdealSystemSize()

    _getLifeTimeValue: ->
      serviceObj._getAnnualValue() * serviceObj.systemLifeYears

    _getMonthlyProduction: ->
      serviceObj.acAnnual / 12 * serviceObj._getIdealSystemSize()
)

.service("Geolocation", ($http) ->
  service =
    get: (options) ->
      params = address: options.zip || 93401

      $http.get(window.gmap_address, params: params)
        .then(service._parseResponse)

    _parseResponse: (resp) ->
      console.log resp
      service.city = resp.data?.results[0].address_components[1].short_name
      service.state = resp.data?.results[0].address_components[2].long_name

    getCity: ->
      service.city

    getState: ->
      service.state
)
