angular.module("app.services")

.service("Referral", ->
  ContactDetails = Parse.Object.extend("Referral");

  save: (details) ->
    contactDetails = new ContactDetails(details)
    contactDetails.save()
)
