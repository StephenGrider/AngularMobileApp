describe 'App Services Geolocation', ->
  http = service = q = null

  beforeEach ->
    module('app')
    inject ($http, Geolocation, $q) ->
      q = $q
      http = $http
      service = Geolocation

  describe '#get', ->
    deferred = null

    beforeEach ->
      deferred = q.defer()
      spyOn(http, 'get').andReturn deferred.promise
      spyOn(service, '_parseResponse')

      service.get(93401)

    it 'makes a request', ->
      expect(http.get).toHaveBeenCalled()

  describe '#getCity', ->
    it 'returns city', ->
      service.city = 'home'
      expect(service.getCity()).toEqual('home')

  describe '#getState', ->
    it 'returns state', ->
      service.state = 'asdf'
      expect(service.getState()).toEqual('asdf')
