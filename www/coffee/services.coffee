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
  kwhCost = .15
  systemLifeYears = 25

  serviceObj =
    get: (options) ->
      params =
        api_key: window.nrel_key
        address: options?.zip || 93401
        system_capacity: '5'
        module_type: 0
        losses: 4
        array_type: 1
        tilt: 14
        azimuth: 180

      _.extend(params, options?.params)

      $http.get(url, params: params)
        .then(serviceObj._parseResponse)

    _parseResponse: (resp) ->
      serviceObj.acAnnual = resp.data.outputs.ac_annual
      serviceObj.acMonthly = resp.data.outputs.ac_monthly

    _getMonthlyValue: ->
      _.map(serviceObj.acMonthly, (monthly) -> monthly * kwhCost)

    _getAnnualValue: ->
      serviceObj.acAnnual * kwhCost

    _getMonthlyBillOffset: ->
      serviceObj.getMonthlyBill() - serviceObj._getAnnualValue() / 12

    _getMonthlyBillOffsetPercent: ->
      (serviceObj.getMonthlyBill() - serviceObj._getAnnualValue() / 12)

    _getLifetimeSystemValue: ->
      serviceObj._getAnnualValue() * systemLifeYears

    setMonthlyBill: (monthlyBill) ->
      serviceObj.monthlyBill = monthlyBill

    getMonthlyBill: ->
      serviceObj.monthlyBill

    getProduction: (monthlyBill) ->
      throw new Error('Production data must be loaded') unless serviceObj.acAnnual and serviceObj.acMonthly

      serviceObj.monthlyBill = monthlyBill if monthlyBill

      acAnnual: serviceObj.acAnnual
      acMonthly: serviceObj.acMonthly
      monthlyValue : serviceObj._getMonthlyValue()
      annualValue: serviceObj._getAnnualValue()
      monthlyBillOffset: serviceObj._getMonthlyBillOffset()
      monthlyBillOffsetPercent: serviceObj._getMonthlyBillOffsetPercent()
      lifetimeSystemValue: serviceObj._getLifetimeSystemValue()

)
