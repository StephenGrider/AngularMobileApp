angular.module("app.services", [])

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
