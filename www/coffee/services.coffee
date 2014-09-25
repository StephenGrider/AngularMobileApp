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

    $http.get url, params: params
)
