describe 'App Services GuideStorage', ->
  beforeEach ->
    module('app')

  guides = service = null

  beforeEach ->
    localStorage.clear()
    guides = [{title: 'hi', id: 0, text: 'yo'}]
    inject ($http, GuideStorage) ->
      service = GuideStorage

  describe '#getGuideStatus', ->

    describe 'guide does not exist in localstorage', ->
      it 'sets guide to empty object', ->
        service.getGuideStatus(guides)
        expect(localStorage.getItem('_solar:guide')).toEqual('{}')

    describe 'guide exists in localstorage', ->
      it 'mashes guide status with guides collection', ->
        localStorage.setItem('_solar:guide', JSON.stringify({0: true}))
        service.getGuideStatus(guides)

        expect(guides[0].hasRead).toEqual(true)

  describe '#setGuideStatus', ->
    it 'updates hasRead for id', ->
      localStorage.setItem('_solar:guide', JSON.stringify({0: false}))
      service.setGuideStatus(0, true)
      
      expect(JSON.parse(localStorage.getItem('_solar:guide'))[0]).toEqual(true)
