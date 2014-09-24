describe 'App Services Financials', ->
  beforeEach ->
    module('app')

  http = service = null

  beforeEach ->
    inject ($http, Financials) ->
      service = Financials
      http = $http

  it 'makes a request', ->
    spyOn(http, 'get')
    service.get()
    expect(http.get).toHaveBeenCalled()

  it 'options are used as query params', ->
    options = {
      params:
        user: 'name'
    }

    spyOn(http, 'get')
    service.get(options)

    args = http.get.mostRecentCall.args
    expect(args[1].params.user).toEqual('name')
