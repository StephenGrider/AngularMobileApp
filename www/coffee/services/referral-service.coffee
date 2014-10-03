angular.module("app.services")

.factory("Referral", ->
  ContactDetails = Parse.Object.extend("Referral");

  save: (details) ->
    contactDetails = new ContactDetails(details)
    contactDetails.save()
)
