describe 'App Services GuideContent', ->
  beforeEach ->
    module('app')

  http = service = null

  beforeEach ->
    inject ($http, GuideContent) ->
      service = GuideContent
      http = $http

  it 'issues a get to content/guide.json', ->
    spyOn(http, 'get')
    service.getAll()
    expect(http.get).toHaveBeenCalledWith('content/guide.json')

  it 'returns result from http.get', ->
    spyOn(http, 'get').andReturn('a value')
    expect(service.getAll()).toEqual('a value')
