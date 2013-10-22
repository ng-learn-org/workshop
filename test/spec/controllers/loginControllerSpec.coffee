#describe "Login Controller", ->
#
#  # load the controller's module
#  beforeEach module("myStoreApp")
#
#  loginController = scope = location = profileService = undefined
#
#  # Initialize the controller
#  beforeEach inject ($controller, $rootScope, $location, _profileService_) ->
#    location = $location
#    scope = $rootScope.$new()
#
#    # The injector unwraps the underscores (_) from around the parameter names when matching
#    profileService = _profileService_
#
#    loginController = $controller "loginController",
#      $scope: scope
#
#  describe "When clicking the submit button", ->
#
#    it "should go to the welcome page", ->
#
#      # Create spy on our service. Intercept the call to our login method. We do not care about its internal implementation or response
#      profileSpyOn = spyOn(profileService, "login")
#
#      scope.submit()
#
#      expect(profileSpyOn).toHaveBeenCalled()
#      expect(location.path()).toBe("/welcome")

describe "Login Controller", ->

  # load the controller's module
  beforeEach module("myStoreApp")

  loginController = scope = location = fakeProfileService = undefined

  # Initialize the controller
  beforeEach inject ($controller, $rootScope, $location) ->
    location = $location
    scope = $rootScope.$new()

    # We create a fake profile Service that fulfills the login function
    fakeProfileService =
      login: ()->
        return null

    # We create the controller passing the profile service implementation to be injected.
    loginController = $controller "loginController",
      $scope: scope
      profileService: fakeProfileService

  describe "When clicking the submit button", ->

    it "should go to the welcome page", ->

      # Create spy on our service. Intercept the call to our login method. We do not care about its internal implementation or response
      profileSpyOn = spyOn(fakeProfileService, "login")

      scope.submit()

      expect(profileSpyOn).toHaveBeenCalled()
      expect(location.path()).toBe("/welcome")