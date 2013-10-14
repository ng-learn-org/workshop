describe "Controller: WelcomeController", ->

  # load the controller's module
  beforeEach module("myStoreApp")

  welcomeController = scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()

    scope.profile =
      firstName: "Santiago"
      lastName: "Esteva"

    welcomeController = $controller("welcomeController",
      $scope: scope
    )
  )

  it "should attach a list of awesomeThings to the scope", ->
    expect(scope.fullName).toBe "Santiago Esteva"

