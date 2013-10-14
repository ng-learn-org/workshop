angular.module("myStoreApp", []).
  run ->
    console.log 'Its alive!'

angular.module("myStoreApp").controller "welcomeController", ["$scope", ($scope)->

  $scope.userName = "Santiago"


]