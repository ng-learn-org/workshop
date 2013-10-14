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

  it "should compose the fullName based on firstName and lastName attributes from prexisting profile object", ->
    expect(scope.fullName).toBe "Santiago Esteva"

