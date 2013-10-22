# Define main module and its dependencies
angular.module('myStoreApp', [])

# Add configuration to the module; such as routes
angular.module("myStoreApp").config ($routeProvider) ->

  # When the url matches / then we inject the login html
  $routeProvider.when("/",
    templateUrl: "views/login.html"
  ).when("/welcome",
    templateUrl: "views/welcome.html"
  )

# Add a run block. This is executed only once when the app is bootstrapped.
angular.module("myStoreApp").run ($rootScope) ->
    console.log 'Its alive!'

    # Prexisting profile object
    $rootScope.profile =
      firstName: "Santiago"
      lastName: "Esteva"

# Add a controller to our main module/
angular.module("myStoreApp").controller "welcomeController", ["$scope", ($scope)->

  $scope.fullName = $scope.profile.firstName + " " +  $scope.profile.lastName

]

angular.module("myStoreApp").controller "loginController", ["$scope","$location","profileService", ($scope, $location, Profile)->

  $scope.submit = ()->
    Profile.login("user", "password")
    $location.path "/welcome"

]

angular.module("myStoreApp").service "profileService", [ "myFakeDb" , (myFakeDb)->

  # private functions
  retrieveProfile = (user, password)->

    matchedProfile = undefined

    angular.forEach myFakeDb.profiles, (profile, key)->
      if profile.user is user then matchedProfile = profile

    return matchedProfile

  # public functions
  login: retrieveProfile

]

angular.module("myStoreApp").constant "myFakeDb",

  profiles: [
    user: "myUser"
    password: "myPassword"
    fullName: "Santiago Esteva"
  ,
    user: "anotherUser"
    password: "hisPassword"
    fullName: "John Doe"
  ]
