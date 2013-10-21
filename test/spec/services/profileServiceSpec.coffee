describe "Profile Service", ->

  # load the controller's module
  beforeEach module("myStoreApp")

  profileService = undefined

  # create an instance of the ProfileService and assign it to my local variable
  beforeEach inject ($injector) ->
    profileService = $injector.get 'profileService'

  it "login user with username and password", ->
    profile = profileService.login("myUser", "myPassword")
    expect(profile.fullName).toBe("MyFullName")


