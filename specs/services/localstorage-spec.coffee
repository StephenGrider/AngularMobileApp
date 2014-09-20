describe 'App Services LocalStorage', ->
  beforeEach ->
    module('app')

  service = null

  beforeEach ->
    window.localStorage.clear()
    inject (LocalStorage) -> service = LocalStorage

  it 'can set primitive items in localStorage', ->
    service.set('hat', 'bat')

    expect(JSON.parse(localStorage.getItem('_solar:hat'))).toEqual('bat')

  it 'gets items from localStorage', ->
    localStorage.setItem('_solar:hat', JSON.stringify('bat'))
    expect(service.get('hat')).toEqual('bat')

  it 'parses and stringifies json input', ->
    obj = hat: 'bat'
    service.set('key', obj)

    expect(JSON.parse(localStorage.getItem('_solar:key')).hat).toEqual('bat')
