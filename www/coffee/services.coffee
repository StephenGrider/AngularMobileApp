angular.module("starter.services", [])

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

    _(guides).each (guide) ->
      guide.hasRead = storage[guide.id] || false

  setGuideStatus: (id, hasRead) ->
    storage = LocalStorage.get("guide")
    storage[id] = hasRead
    LocalStorage.set("guide", storage)
)
