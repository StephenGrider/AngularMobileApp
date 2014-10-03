angular.module("app.services")

.factory("Geolocation", ($http) ->
  service =
    get: (options) ->
      params = address: options.zip || 93401

      $http.get(window.gmap_address, params: params)
        .then(service._parseResponse)

    _parseResponse: (resp) ->
      service.city = resp.data?.results[0].address_components[1].short_name
      service.state = resp.data?.results[0].address_components[2].long_name

    getCity: ->
      service.city

    getState: ->
      service.state
)
