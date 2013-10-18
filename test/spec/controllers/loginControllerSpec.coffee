describe "Login Controller", ->

  # load the controller's module
  beforeEach module("myStoreApp")

  loginController = scope = location = undefined

  # Initialize the controller
  beforeEach inject ($controller, $rootScope, $location) ->
    location = $location
    scope = $rootScope.$new()

    loginController = $controller "loginController",
      $scope: scope

  describe "When clicking the submit button", ->

    it "should go to the welcome page", ->
      scope.submit()
      expect(location.path()).toBe("/welcome")


