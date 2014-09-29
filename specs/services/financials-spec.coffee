describe 'App Services Financials', ->
  http = service = q = null

  beforeEach ->
    module('app')
    inject ($http, Financials, $q) ->
      q = $q
      http = $http
      service = Financials
      service.kwhCost = .17
      service.systemLifeYears = 25

  requestData =
    data:
      outputs:
        "ac_annual" : 1811.012939453125,
        "ac_monthly" : [ 100.66162872314453, 111.26215362548828, 148.64268493652344, 173.8405303955078, 198.34715270996094, 185.92239379882812, 198.8274383544922, 189.72244262695312, 158.1148681640625, 135.3782501220703, 106.55976104736328, 103.73392486572266],
        "dc_monthly" : [ 105.25746154785156, 116.24359130859375, 155.22824096679688, 181.6504364013672, 207.43527221679688, 194.4212646484375, 207.5327911376953, 197.98968505859375, 165.12161254882812, 141.3495635986328, 111.36937713623047, 108.31517791748047],
        "poa_monthly" : [ 114.88142395019531, 126.53730773925781, 169.32899475097656, 198.7964324951172, 225.47720336914062, 212.1094512939453, 232.9950714111328, 221.6403350830078, 183.57229614257812, 157.56224060058594, 121.58546447753906, 117.31389617919922],
        "solrad_annual" : 5.696845531463623,
        "solrad_monthly" : [ 3.7058522701263428, 4.519189357757568, 5.462225437164307, 6.626547813415527, 7.273458003997803, 7.070314884185791, 7.515970230102539, 7.149688243865967, 6.119076728820801, 5.082653045654297, 4.052848815917969, 3.7843191623687744]


  it 'makes a request', ->
    spyOn(http, 'get').andReturn(q.defer().promise)
    service.get()
    expect(http.get).toHaveBeenCalled()

  it 'options are used as query params', ->
    options = {
      params:
        user: 'name'
    }

    spyOn(http, 'get').andReturn(q.defer().promise)
    service.get(options)

    args = http.get.mostRecentCall.args
    expect(args[1].params.user).toEqual('name')

  it '#_parseResponse', ->
    service._parseResponse(requestData)

    expect(service.acAnnual).toEqual(1811.012939453125)
    expect(service.acMonthly[0]).toEqual(100.66162872314453)

  it '#setMonthlyBill', ->
    expect(service.monthlyBill).toBeUndefined()

    service.setMonthlyBill(200)
    expect(service.monthlyBill).toEqual(200)

  it '#_getIdealSystemSize', ->
    service.setMonthlyBill(200)
    ideal = 12*200 / service.kwhCost / requestData.data.outputs.ac_annual

    service._parseResponse(requestData)

    expect(service._getIdealSystemSize()).toEqual(ideal)

  it '#_getAnnualValue', ->
    service._parseResponse(requestData)
    value = service.kwhCost * service.acAnnual * service.systemLifeYears
    spyOn(service, '_getIdealSystemSize').andReturn(1)


    expect(service._getAnnualValue()).toEqual(value)

  it '#_getLifeTimeValue', ->
    spyOn(service, '_getAnnualValue').andReturn(3)
    service.systemLifeYears = 25

    expect(service._getLifeTimeValue()).toEqual(75)
