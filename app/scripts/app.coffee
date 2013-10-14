angular.module("myStoreApp", []).
  run ($rootScope) ->
    console.log 'Its alive!'

    # Prexisting profile object
    $rootScope.profile =
      firstName: "Santiago"
      lastName: "Esteva"

angular.module("myStoreApp").controller "welcomeController", ["$scope", ($scope)->

  $scope.fullName = $scope.profile.firstName + " " +  $scope.profile.lastName

]