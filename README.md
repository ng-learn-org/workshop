### PreRequisites

- Install Node and NPM

### Setup

    git clone https://github.com/ng-learn-org/workshop.git
    cd workshop
    npm install

### Step 0 - Setup the AngularJs App

    git checkout -f step-0

- Add AngularJs library to our index.html

    ``` html
      <div>Welcome to the AngularJS World</div>
      
      <script src="bower_components/angular/angular.js"></script>
    
    </body>
    ```

- Bootstrap the AngularJS app using the automatic method

    ``` html
    <body ng-app>
    ```

- Lets update our welcome message

    ``` html
    <div>Welcome to the AngularJS World, {{userName}}</div>
    ```

- Start the app

    ``` coffeescript
    grunt server
    ```

  **Notes:** The application should say "Welcome to the AngularJS World," but the "{{userName}}" portion should not be visible. Angular has kicked in and it does not display it because that variable is not binded to anything, yet!

### Step 1 - Defining our first module

    git checkout -f step-1

- Lets name our application

    ``` html
    <body ng-app="myStoreApp">
    ```

- Create app.coffee inside app folder and define our application in app.coffee

    ``` coffeescript
    angular.module("myStoreApp", [])
    ```

  **Notes:** Here we define a module named 'myStoreApp'. The second parameter it is an array of dependencies required for this module.

- Add app.js to our index.html so the browser will load it

    ``` html
      <div>Welcome to the AngularJS World</div>
   
      <script src="bower_components/angular/angular.js"></script>
   
      <!-- build:js({.tmp,app}) scripts/scripts.js -->
      <script src="scripts/app.js"></script>
      <!-- endbuild -->
    </body>
    ```

  **Notes:** we add our js file wrapped in a 'build comment' so our toolchain converts it from coffee script to javascript.

- To prove our point, we will add a Run block to our module. Run blocks are the closest thing in Angular to the main method in Java.
  It will be executed after all the dependencies have been injected. Open app.coffee and make the following modification

    ``` coffeescript
    angular.module("myStoreApp", []).
      run ->
        console.log 'Its alive!'
    ```

  Lets run 'grunt server' in the terminal. This will open a browser with out application. Lets open the developer tools and on the console you should find "Its alive!".
  Congratulations. You've created your first Angular module.

### Step 2 - Defining our first controller

    git checkout -f step-2

- Now we are going to create a controller and provide our application some behaviour. Open index.html and lets add ng-controller to our div.

 ``` html
 <div ng-controller="welcomeController">Welcome to the AngularJS World, {{userName}}</div>
 ```

 **Notes:** When you do this, Angular will look for a controller - inside of our myStoreApp module - called welcomeController. This controller will only have power over whats happening inside our 'div'. We will refer to this domain as scope.

 Lets run the app and see what happens. The application will run without obvious problems. Now if we open the developer tools and take a look at the console we are going to see an error. This error is telling us the controller we are trying to use, it is not yet defined.

 - Lets define our controller. Open app.coffee and make the following modifications.

 ``` coffeescript
 angular.module("myStoreApp").controller "welcomeController", ["$scope", ($scope) ->
   $scope.userName = "Santiago Esteva"
 ]
 ```

 **Notes:** A few things have happened.
    - We just created a new controller inside our module. We named it "welcomeController".
    - When we use a module we do not declare its dependencies. We declare dependencies only the first time we defined the module.
    - After naming our controller, we pass its dependencies **' ["$scope", '** and then we defined the name these dependencies will have locally **' ($scope) -> '**. This means that we could have renamed them to whatever we wanted. **Example:  angular.module("myStoreApp").controller "welcomeController", ["$scope", (localScope) -> .**
As a best practice we keep the same names, specially when we deal with Angular objects.

 Let's open the application and see what we have. The application should not have any error and now you should see "Welcome to the AngularJS World, Santiago"


- Finally, lets make a few more changes on our index.html.

 ``` html
 <div ng-controller="welcomeController">
     Welcome to the AngularJS World, {{userName}}
     <hr>
     <p>Inside the controller: <input name="userName" ng-model="userName"/></p>
 </div>
 <hr>
 <div>
     <p>Outside the controller: <input name="userName" ng-model="userName"/></p>
 </div>
 ```

 Now, lets play with the inputs and lets see what happens. As you can see the first input generates the Bidirectional binding between the input and the welcome phrase.
 This is Angular magic. the userName variable exists under an specific scope, the controller's scope. This is why the input that exists outside our controller does not change and when we enter text it does not change the welcome phrase.

### Step 3 - Our first Requirement

    git checkout -f step-3

 If you get "Karma is not a task" or "Karma is not found". Please execute "npm install grunt-karma --save-dev" on the terminal.

 **AC:** As a User, when I open myStore home page, then I should see the phrase "Welcome to the AngularJS World, {{fullName}}".

 **Assumptions:** The application already has an object called profile that contains firstName and lastName.

 - **Development Flow - Unit Test:** Now that we know our AC, we need to write our first unit test. Under test lets create a folder spec and a subfolder called controllers. And inside lets create a file called welcomeControllerSpec.coffee

  ``` coffeescript
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
  ```

  Lets run the tests, go to the console and execute 'grunt test'. You will see "Expected undefined to be 'Santiago Esteva'." and "PhantomJS 1.9.2 (Linux): Executed 1 of 1 (1 FAILED) ERROR (0.183 secs / 0.009 secs)"
  That's actually great. This is the expected output. Now we have a failing unit test that we can code against. Kudos!




















